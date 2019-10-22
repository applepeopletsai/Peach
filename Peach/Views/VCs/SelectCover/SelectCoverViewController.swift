//
//  SelectCoverViewController.swift
//  Peach
//
//  Created by Daniel on 14/10/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import AVFoundation

class SelectCoverViewController: CoreCollectionVC {

    //MARK:- Property
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var images: [UIImage]?
    private var video: AVAsset?
    private var collectionLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        
        let width = 100
        layout.itemSize = CGSize(width: width, height: width)
        return layout
    }
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar()
        self.configureCollectionView()
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, video: AVAsset, images: [UIImage]) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.video = video
        self.images = images
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setVMAndRouter() {
        super.setVMAndRouter()
        
        let vm = SelectVideoImageVM()
        vm.items = vm.dataConverter(data: images ?? [])
        self.viewModel = vm
    }
    
    //MARK:- Private Function
    private func configureNavigationBar() {
        self.navigationItem.title = "photo_9".localized
        self.addImageBackBtn()
        
        self.addCustomRightNaviItem {
            self.nextButtoonPress()
        }
    }
    
    private func configureCollectionView() {
        self.setCollectionView(collectionView: self.collectionView, layout: self.collectionLayout)
        self.collectionView.delegate = self
        
        //default select first image
        self.collectionView.layoutIfNeeded()
        let defaultSelectIndexPath = IndexPath(row: 0, section: 0)
        self.collectionView.selectItem(at: defaultSelectIndexPath, animated: false, scrollPosition: .left)
        self.collectionView(self.collectionView, didSelectItemAt: defaultSelectIndexPath)
    }
    
    private func nextButtoonPress() {
        guard let image = self.coverImageView.image else { return }
        UploadPostRouter().route(to: UploadPostRouterID.upLoadPhoto.rawValue, from: self, parameters: [image])
    }
}

extension SelectCoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vm = self.viewModel as? SelectVideoImageVM else { return }
        
        let image = vm.didSelectItemAt(indexPath)
        self.coverImageView.image = image
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.alpha = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.alpha = 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.alpha = (cell.isSelected) ? 1 : 0.5
    }
}
