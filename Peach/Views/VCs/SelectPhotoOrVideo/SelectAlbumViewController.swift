//
//  SelectAlbumViewController.swift
//  Peach
//
//  Created by Daniel on 4/10/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import Photos

class SelectAlbumViewController: UITableViewController {

    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.tableView.backgroundColor = .clear
        self.navigationController?.navigationItem.title = "相簿"
        
        //Fetch user albums
        let options = PHFetchOptions()
        allPhotos = PHAsset.fetchAssets(with: .image, options: options)
        var subtypes: [PHAssetCollectionSubtype] = [.smartAlbumVideos, .smartAlbumPanoramas, .smartAlbumSelfPortraits, .smartAlbumScreenshots]
        if #available(iOS 10.2, *) {
            subtypes.append(.smartAlbumDepthEffect)
        }
        smartAlbums = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: self.fetchSmartCollectionsLocalIdentifier(with: .smartAlbum, subtypes: subtypes), options: options)
        
        //PHPhotoLibraryChangeObserver
        PHPhotoLibrary.shared().register(self)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    //MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + smartAlbums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AlbumCell")
        }
        
        if indexPath.row == 0 {
            cell?.textLabel?.text = "照片"
            cell?.detailTextLabel?.text = String(allPhotos.count)
            
            self.fetchImage(asset: allPhotos.lastObject!, imageSize: CGSize(width: 30, height: 30), completion: { image in
                cell?.imageView?.image = image
            })
        } else {
            let index = indexPath.row - 1
            
            let collection: PHAssetCollection = smartAlbums.object(at: index)
            cell?.textLabel!.text = collection.localizedTitle
            
            //相簿中所有相片
            let option = PHFetchOptions()
            option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            let result: PHFetchResult = PHAsset.fetchAssets(in: collection, options: option)
            
            //獲取相簿最後一張照片
            if let lastAsset = result.lastObject {
                self.fetchImage(asset: lastAsset, imageSize: CGSize(width: 30, height: 30), completion: { image in
                    cell?.imageView?.image = image
                })
            } else {
                cell?.imageView?.image = nil
            }
            
            cell?.detailTextLabel?.text = String(result.count)
            cell?.imageView?.contentMode = .scaleAspectFill
        }
        
        return cell ?? UITableViewCell()
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //MARK: - Private Function
    private func fetchSmartCollectionsLocalIdentifier(with: PHAssetCollectionType, subtypes: [PHAssetCollectionSubtype]) -> [String] {
        var localIdentifiers: [String] = []
        let options = PHFetchOptions()
        options.includeHiddenAssets = false
        
        for subtype in subtypes {
            if let collection = PHAssetCollection.fetchAssetCollections(with: with, subtype: subtype, options: options).firstObject {
                localIdentifiers.append(collection.localIdentifier)
            }
        }
        
        return localIdentifiers
    }
    
    private func fetchImage(asset: PHAsset, imageSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let option: PHImageRequestOptions = PHImageRequestOptions()
        option.resizeMode = .fast
        option.deliveryMode = .fastFormat
        option.isSynchronous = true
        option.isNetworkAccessAllowed = false
        
        PHCachingImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: option, resultHandler: {
            image, info in
            completion(image)
        })
    }
}

extension SelectAlbumViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        DispatchQueue.main.sync {
            
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changeDetails.fetchResultAfterChanges
            }
            
//            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
//                smartAlbums = changeDetails.fetchResultAfterChanges
//            }
//            if let changeDetails = changeInstance.changeDetails(for: userAlbums) {
//                userAlbums = changeDetails.fetchResultAfterChanges
//            }
            
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic) 
        }
    }
}
