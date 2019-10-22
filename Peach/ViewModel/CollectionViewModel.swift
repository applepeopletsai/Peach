//
//  CollectionViewModel.swift
//  Peach
//
//  Created by dean on 2019/8/12.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class CollectionViewModel: BaseVM {}

extension CollectionViewModel : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?[section].rows.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let item = items?[indexPath.section].rows[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(with: item.collectionViewCell ?? UICollectionViewCell.self, for: indexPath)
            
            if cell.isKind(of: CoreCollectionViewCell.self) {
                let cell = cell as? CoreCollectionViewCell
                cell?.item = item
            }
            return cell
        }
        
        let cell = UICollectionViewCell(frame: CGRect.zero)
        return cell
    }
    
    
}
