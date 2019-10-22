//
//  SelectAssetVM.swift
//  Peach
//
//  Created by Daniel on 5/10/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import Photos

extension RowTypes {
    static let selectAsset = RowTypes(rawValue: "selectAsset")
}

extension SectionTypes {
    static let selectAsset = SectionTypes(rawValue: "selectAsset")
}

class CustomAsset {
    var originAsset: PHAsset
    var selected: Bool
    var selectIndex: Int?
    
    init(originAsset: PHAsset, selected: Bool, selectIndex: Int? = nil) {
        self.originAsset = originAsset
        self.selected = selected
        self.selectIndex = selectIndex
    }
    
    init() {
        self.originAsset = PHAsset()
        self.selected = false
    }
}

class SelectAssetVM: BaseVM {
    var type: AssetType = .photo
    
    private var photoFetchResult: PHFetchResult<PHAsset>!
    private let imageManager = PHCachingImageManager()
    private var previousPreheatRect = CGRect.zero
    private var thumbnailSize: CGSize = .zero
    private var maxPhotoCount = 10
    private var maxVideoCount = 1
    
    private var selectImageIdentifiers: [String] = []
    private var selectVideoIdentifiers: [String] = []
    
    //MARK:- Initialize
    init(thumbnailSize: CGSize) {
        self.thumbnailSize = thumbnailSize
    }
    
    //MARK: Public Function
    func fetchAsset(type: AssetType) -> Array<SectionItemProtocol> {
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let mediaType: PHAssetMediaType = (type == .photo) ? .image: .video
        self.type = type
        photoFetchResult = PHAsset.fetchAssets(with: mediaType, options: option)
        
        let sectionItem = self.transferPhotoFetchResult()
        return sectionItem
    }
    
    func updateCachedAssets(targetView:UIView, collectionView: UICollectionView) {
        
        // The preheat window is twice the height of the visible rect.
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)

        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > targetView.bounds.height / 3 else { return }

        // Compute the assets to start caching and to stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects.flatMap { (rect) -> [IndexPath] in
            return collectionView.indexPathsForElements(in: rect)
        }.map { (indexPath) -> PHAsset in
            guard let sectionItem = self.items?[indexPath.section], let rowItem = sectionItem.rows[indexPath.row] as? ListRowItem, let dic = rowItem.value as? [String:Any], let asset = dic["photo"] as? CustomAsset else { return PHAsset() }
            return asset.originAsset
        }
        
        let removedAssets = removedRects.flatMap { (rect) -> [IndexPath] in
            return collectionView.indexPathsForElements(in: rect)
        }.map { (indexPath) -> PHAsset in
            guard let sectionItem = self.items?[indexPath.section], let rowItem = sectionItem.rows[indexPath.row] as? ListRowItem, let dic = rowItem.value as? [String:Any], let asset = dic["photo"] as? CustomAsset else { return PHAsset() }
            return asset.originAsset
        }

        let option: PHImageRequestOptions = PHImageRequestOptions()
        option.resizeMode = .none
        option.deliveryMode = .highQualityFormat
        
        // Update the assets the PHCachingImageManager is caching.
        imageManager.startCachingImages(for: addedAssets,
            targetSize: thumbnailSize, contentMode: .aspectFill, options: option)
        imageManager.stopCachingImages(for: removedAssets,
            targetSize: thumbnailSize, contentMode: .aspectFill, options: option)

        // Store the preheat rect to compare against in the future.
        previousPreheatRect = preheatRect
    }

    func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    func photoLibraryDidChange(changeInstance: PHChange, collectionView: UICollectionView) {
        guard let changes = changeInstance.changeDetails(for: photoFetchResult)
            else { return }
        
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            photoFetchResult = changes.fetchResultAfterChanges
            self.items = self.transferPhotoFetchResult()
            
            if changes.hasIncrementalChanges {
                // If we have incremental diffs, animate them in the collection view.
                
                collectionView.performBatchUpdates({
                    // For indexes to make sense, updates must be in this order:
                    // delete, insert, reload, move
                    if let removed = changes.removedIndexes, removed.count > 0 {
                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, inserted.count > 0 {
                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let changed = changes.changedIndexes, changed.count > 0 {
                        collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                to: IndexPath(item: toIndex, section: 0))
                    }
                })
            } else {
                // Reload the collection view if incremental diffs are not available.
                collectionView.reloadData()
            }
            resetCachedAssets()
        }
    }
    
    func canSelectAsset(indexPath: IndexPath) -> Bool {
        if self.type == .video { return true }
        guard let rows = self.items?[indexPath.section].rows, let dic = rows[indexPath.row].value as? [String:Any], let selectAsset = dic["photo"] as? CustomAsset else { return false }
        if selectAsset.selected { return true }
        return selectImageIdentifiers.count < maxPhotoCount
    }
    
    func shouldShowNextStepButton() -> Bool {
        if self.type == .photo {
            return self.selectImageIdentifiers.count > 0
        } else {
            return self.selectVideoIdentifiers.count > 0
        }
    }
    
    func fetchSelectPhoto(completion: @escaping ([UIImage]) -> Void) {
        var dic: [String:UIImage] = [:]
        
        for i in 0..<photoFetchResult.count {
            let asset = photoFetchResult.object(at: i)
            
            if selectImageIdentifiers.contains(asset.localIdentifier) {
                dic["\(asset.localIdentifier)"] = UIImage()
                
                //避免resultHandler跑兩次(會先給一次低解析度的image,再給原圖)，將isSynchronous設為true
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .default, options: option, resultHandler: { image, info in
                    
                    if let image = image {
                        dic["\(asset.localIdentifier)"] = image
                    } else {
                        print("Fetch Image Fail")
                    }
                    
                    if dic.count == self.selectImageIdentifiers.count {
                        let result = dic.map{ $0.value }
                        DispatchQueue.main.async {
                            completion(result)
                        }
                    }
                })
            }
        }
    }
    
    func fetchSelectVideo(completion: @escaping ([UIImage], AVAsset) -> Void) {
        for i in 0..<photoFetchResult.count {
            let asset = photoFetchResult.object(at: i)
            
            if selectVideoIdentifiers.contains(asset.localIdentifier) {
                
                imageManager.requestAVAsset(forVideo: asset, options: nil, resultHandler: { (avAsset, _, _) in
                    if let video = avAsset {
                        VideoHelper.shared.fetchVideoImage(video: video, completion: { images in
                            completion(images, video)
                        })
                    } else {
                        print("Fetch Video  fail")
                    }
                })
            }
        }
    }
    
    func didSelectItemAt(_ indexPath: IndexPath) -> [IndexPath] {
        guard let rows = self.items?[indexPath.section].rows, let dic = rows[indexPath.row].value as? [String:Any], let selectAsset = dic["photo"] as? CustomAsset else { return [] }
        
        //先找出要reload的indexpath
        let changeIndexPaths = rows.enumerated().flatMap { (obj) -> [IndexPath] in
            guard let dic = obj.element.value as? [String:Any], let asset = dic["photo"] as? CustomAsset else { return [] }
            
            var result: [IndexPath] = []
            if asset.selected || (!selectAsset.selected && asset.originAsset.localIdentifier == selectAsset.originAsset.localIdentifier) { result.append(IndexPath(row: obj.offset, section: 0)) }
            
            if self.type == .video {
                if asset.selected, asset.originAsset.localIdentifier == selectAsset.originAsset.localIdentifier {
                    return []
                } else {
                    asset.selected = false
                }
            }
            return result
        }
        
        if changeIndexPaths.count == 0 { return changeIndexPaths }
        
        selectAsset.selected = !selectAsset.selected
        
        if self.type == .photo {
            if let index = selectImageIdentifiers.firstIndex(of: selectAsset.originAsset.localIdentifier) {
                selectImageIdentifiers.remove(at: index)
            } else {
                selectImageIdentifiers.append(selectAsset.originAsset.localIdentifier)
            }
        } else {
            selectVideoIdentifiers.removeAll()
            selectVideoIdentifiers.append(selectAsset.originAsset.localIdentifier)
//            if let index = selectVideoIdentifiers.firstIndex(of: selectAsset.originAsset.localIdentifier) {
//                selectVideoIdentifiers.remove(at: index)
//            } else {
//                selectVideoIdentifiers.append(selectAsset.originAsset.localIdentifier)
//            }
        }
        
        self.updateSelectIndex(updateIndex: changeIndexPaths.map{ $0.row })
        
        return changeIndexPaths
    }
    
    func playVideo(in cell: SelectAssetCollectionViewCell?) {
        if self.type == .video {
            cell?.playVideo()
        }
    }
    
    func pauseVideo(in cell: SelectAssetCollectionViewCell?) {
        if self.type == .video {
            cell?.pauseVideo()
        }
    }
    
    //MARK:- Private Function
    private func transferPhotoFetchResult() -> Array<SectionItemProtocol> {
        var rows: [ListRowItem] = []
        
        let currentSelectIdentifiers = (self.type == .photo) ? selectImageIdentifiers : selectVideoIdentifiers
        for i in 0..<photoFetchResult.count {
            let phAsset = photoFetchResult.object(at: i)
            let selected = currentSelectIdentifiers.contains(phAsset.localIdentifier)
            let selectIndex = (currentSelectIdentifiers.firstIndex(of: phAsset.localIdentifier) ?? 0) + 1
            rows.append(ListRowItem(type: .selectAsset, value: ["photo":CustomAsset(originAsset: phAsset, selected: selected, selectIndex: selectIndex), "imageManager":imageManager, "thumbnailSize":thumbnailSize], collectionViewCell: SelectAssetCollectionViewCell.self))
        }
        let sectionItem = ListSectionItem(sectionTitle: .selectAsset, rows: rows)
        return [sectionItem]
    }
    
    private func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                    width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                    width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                      width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                      width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
    
    private func updateSelectIndex(updateIndex: [Int]) {
        guard let rows = self.items?.first?.rows else { return }
        
        for index in updateIndex {
            guard let dic = rows[index].value as? [String:Any], let asset = dic["photo"] as? CustomAsset else { break }
            
            let currentSelectIdentifiers = (self.type == .photo) ? selectImageIdentifiers : selectVideoIdentifiers
            if let index = currentSelectIdentifiers.firstIndex(of: asset.originAsset.localIdentifier) {
                asset.selectIndex = index + 1
            } else {
                asset.selectIndex = nil
            }
        }
    }
}
