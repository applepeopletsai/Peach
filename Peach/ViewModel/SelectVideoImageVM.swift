//
//  SelectVideoImageVM.swift
//  Peach
//
//  Created by Daniel on 14/10/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class SelectVideoImageVM: BaseVM {
    
    func dataConverter(data: Any) -> Array<SectionItemProtocol> {
        if let images = data as? [UIImage] {
            let section = ListSectionItem(sectionTitle: .noHeader, rows: [])
            for image in images {
                let value = ["image":image,"shouldSelect":true,"shouldTransparent":true,"shouldShowNumber":false] as [String : Any]
                let row = ListRowItem(type: .imageOnly, value: value, tableViewCell: nil, collectionViewCell: ImageOnlyCollectionViewCell.self)
                section.rows.append(row)
            }
            self.items = [section]
            return [section]
        }
        return []
    }
    
    func didSelectItemAt(_ indexPath: IndexPath) -> UIImage? {
        guard let dic = self.items?[indexPath.section].rows[indexPath.row].value as? [String:Any], let image = dic["image"] as? UIImage else { return nil }
        return image
    }
    
}
