//
//  UploadPhotoVM.swift
//  Peach
//
//  Created by dean on 2019/10/8.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import Foundation

extension SectionTypes {
    static let noHeader = SectionTypes(rawValue: "noHeader")
}
extension RowTypes {
    static let imageOnly = RowTypes(rawValue: "imageOnly")
    
}

class UploadPhotoVM: BaseVM {
    func dataConverter(data: Any) -> Array<SectionItemProtocol> {
        
        if let images = data as? Array<UIImage> {
            var section = ListSectionItem(sectionTitle: .noHeader, rows: [])
            for image in images {
                let row = ListRowItem(type: .imageOnly, value: image, tableViewCell: nil, collectionViewCell: ImageOnlyCollectionViewCell.self)
                section.rows.append(row)
            }
            self.items = [section]
            return [section]
        } else {
            return [ListSectionItem(sectionTitle: .noHeader, rows: [])]
        }
        
    }
}
