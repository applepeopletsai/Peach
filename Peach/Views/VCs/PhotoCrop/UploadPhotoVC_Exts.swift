//
//  UploadPhotoVC_Exts.swift
//  Peach
//
//  Created by dean on 2019/10/8.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import Foundation

extension UploadPhotoVC: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            super.collectionView(collectionView, cellForItemAt: indexPath)
            if let item = self.viewModel?.items?[indexPath.section].rows[indexPath.row] {
                let cell = collectionView.dequeueReusableCell(with: item.collectionViewCell ?? UICollectionViewCell.self, for: indexPath)
                
                if cell.isKind(of: CoreCollectionViewCell.self) {
                    let cell = cell as? ImageOnlyCollectionViewCell
                    cell?.item = item
                    if let totalCount = self.images?.count {
                        cell?.shouldShowNumberLabel(shouldShow:self.shouldShowCellLabel , number: "\(indexPath.row + 1)",totalCount:"\(totalCount)")
                    }
                    
    
                }
                return cell
            }
            
            return UICollectionViewCell(frame: .zero)
        }
}

extension UploadPhotoVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

