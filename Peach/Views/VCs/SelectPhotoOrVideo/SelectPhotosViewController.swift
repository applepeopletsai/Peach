//
//  SelectPhotosViewController.swift
//  Peach
//
//  Created by Daniel on 5/10/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import Photos

enum AssetType: Int {
    case photo = 0, video = 1
}

class SelectPhotosViewController: CoreCollectionVC {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var permissionView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var addAssetButton: UIButton!
    @IBOutlet var assetTypeButtons: [UIButton]!
    
    //當使用者在選取照片或影片並且快速按切換Media Type按鈕切換顯示類型時，collectionView會顯示錯誤的imageView
    //解法：使用collectionView.performBatchUpdates，在reload Item完後才可以切換
    private var canChangeType: Bool = true
    private var collectionLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        
        let width = (kScreenWidth - 3) / 2
        layout.itemSize = CGSize(width: width, height: width)
        return layout
    }
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addImageBackBtn()
        checkPermission()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        resetCachedAssets()
        CustomPlayer.shared.clean()
    }
    
    //MARK:- Private Function
    fileprivate func checkPermission() {
        PhotoHelper.shared.obtainPermission(forMediaSourceType: .photoLibrary, success: {
            self.configureNavigationBar()
            self.configureBottomBar()
            self.configureVM()
            self.configureCollectionView()
            self.addAssetButton.isHidden = false
        }, failure: {
            self.permissionView.isHidden = false
        })
    }
    
    fileprivate func configureVM() {
        /*
         vm不在setVMAndRouter function初始化原因：
         初始化vm會同時初始化PHCachingImageManager，若是使用者不同意相簿權限，在特定ios版本(11.4)會crash
         crash reason：This application is not allowed to access Photo data
         */
        let vm = SelectAssetVM(thumbnailSize: collectionLayout.itemSize)
        vm.items = vm.fetchAsset(type: .photo)
        self.viewModel = vm
    }
    
    fileprivate func configureNavigationBar() {
        self.navigationItem.title = "photo_6".localized
    }
    
    fileprivate func configureBottomBar() {
        self.bottomView.isHidden = false
        assetTypeButtons.forEach { button in
            guard let type = AssetType(rawValue: button.tag) else { return }
            
            if type == .photo {
                button.setTitle("photo_4".localized, for: .selected)
            } else {
                button.setTitle("photo_5".localized, for: .selected)
            }
        }
    }
    
    fileprivate func configureCollectionView() {
        self.setCollectionView(collectionView: self.collectionView, layout: self.collectionLayout)
        self.collectionView.delegate = self
        self.collectionView.isHidden = false
    }
    
    fileprivate func updateCachedAssets() {
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }
        
        guard let vm = self.viewModel as? SelectAssetVM else { return }
        vm.updateCachedAssets(targetView: self.view, collectionView: self.collectionView)
    }
        
    fileprivate func resetCachedAssets() {
        let vm = self.viewModel as? SelectAssetVM
        vm?.resetCachedAssets()
    }
    
    fileprivate func checkShowNextStepButton() {
        guard let vm = self.viewModel as? SelectAssetVM else { return }
        if vm.shouldShowNextStepButton() {
            //下一步
            self.addCustomRightNaviItem(actionHandler: { [weak self] in
                self?.nextStepButtonPress()
            })
        } else {
            self.removeRightNaviItem()
        }
    }
    
    fileprivate func nextStepButtonPress() {
        guard let vm = self.viewModel as? SelectAssetVM else { return }

        if vm.type == .photo {
            vm.fetchSelectPhoto(completion: { images in
                if images.count == 1 {
                    //CropVc
                    UploadPostRouter().route(to: UploadPostRouterID.photoCrop.rawValue, from: self, parameters: images.first)
                } else if images.count > 1 {
                    //MultiCrop
                    UploadPostRouter().route(to: UploadPostRouterID.photosCrop.rawValue, from: self, parameters: images)
                }
            })
        } else {
            vm.fetchSelectVideo(completion: { images, video in
                UploadPostRouter().route(to: UploadPostRouterID.selectVideoImage.rawValue, from: self, parameters: ["video":video,"images":images])
            })
        }
    }
    
    //MARK:- Action Handler
    @IBAction fileprivate func permissionButtonPress(_ sender: UIButton) {
        self.gotoSetting()
    }
    
    @IBAction fileprivate func addAssetButtonPress(_ sender: UIButton) {
        guard let vm = self.viewModel as? SelectAssetVM else { return }
        
        let routerID = (vm.type == .photo) ? UploadPostRouterID.takePhoto.rawValue : UploadPostRouterID.video.rawValue
        UploadPostRouter().route(to: routerID, from: self, parameters: nil)
    }
    
    @IBAction fileprivate func assetTypeButtonPress(_ sender: UIButton) {
        if !canChangeType { return }
        
        guard let type = AssetType(rawValue: sender.tag), let vm = self.viewModel as? SelectAssetVM, type != vm.type else { return }
        
        for button in assetTypeButtons {
            button.isSelected = button.tag == sender.tag
            
            let buttonType = AssetType(rawValue: button.tag)
            if buttonType == .some(.photo) {
                button.setImage((button.isSelected) ? nil : UIImage(named: "btn_photo"), for: .normal)
            } else {
                button.setImage((button.isSelected) ? nil : UIImage(named: "btn_video"), for: .normal)
            }
        }
        
        vm.items = vm.fetchAsset(type: type)
        
        self.collectionView.reloadData()
        
        self.addAssetButton.setImage( (type == .photo) ? UIImage(named: "btn_photo_shoot") : UIImage(named: "btn_video_shoot"), for: .normal)
        
        self.checkShowNextStepButton()
    }
}

extension SelectPhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vm = self.viewModel as? SelectAssetVM else { return }
        
        if !vm.canSelectAsset(indexPath: indexPath) {
            let title = "照片最多只能選取10張"
            self.showDefaultAlert(title: title, message: "", okBtnTitle: "好", cancelBtnTitle: nil, complention: {})
            return
        }
       
        //reload ui
        let changeIndexPaths = vm.didSelectItemAt(indexPath)
        
        self.canChangeType = false
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: changeIndexPaths)
        }, completion: { _ in
            self.canChangeType = true
        })
        
        self.checkShowNextStepButton()
        
        //play video when select a video
        let cell = collectionView.cellForItem(at: indexPath) as? SelectAssetCollectionViewCell
        vm.playVideo(in: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let vm = self.viewModel as? SelectAssetVM else { return }
        
        //pause video when select other video
        let cell = collectionView.cellForItem(at: indexPath) as? SelectAssetCollectionViewCell
        vm.pauseVideo(in: cell)
    }
}

extension SelectPhotosViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
}

extension SelectPhotosViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        resetCachedAssets()
        let vm = self.viewModel as? SelectAssetVM
        vm?.photoLibraryDidChange(changeInstance: changeInstance, collectionView: collectionView)
    }
}
