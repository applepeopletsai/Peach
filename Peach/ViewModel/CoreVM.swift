//
//  CoreVM.swift
//  Peach
//
//  Created by dean on 2019/8/6.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class ListSectionItem: SectionItemProtocol {
    var sectionType: SectionTypes
    var value:Any?
    var rows: [RowItemProtocol]
    var tableHeaderFooter:UITableViewHeaderFooterView.Type?
    var collectionHeaderFooter:UICollectionReusableView.Type?
    
    init(sectionTitle: SectionTypes, rows: [RowItemProtocol], tableHeaderFooter: UITableViewHeaderFooterView.Type? = nil, collectionHeaderFooter:UICollectionReusableView.Type? = nil, value:Any? = nil) {
        self.sectionType = sectionTitle
        self.rows = rows
        self.tableHeaderFooter = tableHeaderFooter
        self.collectionHeaderFooter = collectionHeaderFooter
        self.value = value
    }
}

class ListRowItem: RowItemProtocol {
    var rowType: RowTypes
    var value: Any
    var tableViewCell:UITableViewCell.Type?
    var collectionViewCell:UICollectionViewCell.Type?
    
    init(type: RowTypes, value: Any, tableViewCell: UITableViewCell.Type? = nil, collectionViewCell: UICollectionViewCell.Type? = nil) {
        self.rowType = type
        self.value = value
        self.tableViewCell = tableViewCell
        self.collectionViewCell = collectionViewCell
    }
}

protocol CoreVM {
    //datas
    var items:Array<SectionItemProtocol>? { get set }
    //Call API
    func callAPI<Request: ApiTargetType>(service:Request, completion: @escaping (_ isSuccess:Bool,_ statusCode:Int,_ items:Array<SectionItemProtocol>?) -> Void)
    //Data converter, convert to item
    func dataConverter(data:Any) -> Array<SectionItemProtocol>
    //Did select
    func didSelect(_ collectionView: UICollectionView?,_ tableView: UITableView?,indexPath:IndexPath)
}

extension CoreVM {
    
    var items:Array<SectionItemProtocol>? {
        get {
            return items
        }
        set(newValue) {
            self.items = newValue
        }
    }
    
    func callAPI<Request>(service: Request, completion: @escaping (_ isSuccess:Bool,_ statusCode:Int,Array<SectionItemProtocol>?) -> Void) where Request : ApiTargetType {
    }
    
    func dataConverter(data: Any) -> Array<SectionItemProtocol> {
        return [SectionItemProtocol]()
    }
    
    func didSelect(_ collectionView: UICollectionView?,_ tableView: UITableView?,indexPath:IndexPath) {
        
    }
}

/// Conform this protocol to handles user press action
protocol CellPressible {
    var cellPressed: (()->Void)? { get set }
}

@objc class BaseVM:NSObject, CoreVM {
    var items:Array<SectionItemProtocol>? = [SectionItemProtocol]()
}


