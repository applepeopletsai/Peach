//
//  MultiCropperVM.swift
//  Peach
//
//  Created by dean on 2019/10/9.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import Foundation

class MultiCropperVM :BaseVM {
    func dataConverter(data: Any) -> Array<SectionItemProtocol> {
        
        if let images = data as? Array<UIImage> {
            var section = ListSectionItem(sectionTitle: .noHeader, rows: [])
            for image in images {
                let value = ["image":image,"shouldSelect":true] as [String : Any]
                let row = ListRowItem(type: .imageOnly, value: value, tableViewCell: nil, collectionViewCell: ImageOnlyCollectionViewCell.self)
                section.rows.append(row)
            }
            self.items = [section]
            return [section]
        } else {
            return [ListSectionItem(sectionTitle: .noHeader, rows: [])]
        }
        
    }
}
