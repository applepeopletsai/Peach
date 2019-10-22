//
//  GlobalData.swift
//  BlockchainWallet_Swift
//
//  Created by Daniel on 2019/6/6.
//  Copyright © 2019 Daniel. All rights reserved.
//

import UIKit

class GlobalData {
    static let shared = GlobalData(token: "")
    
    var token: String = ""
    
    private init(token:String) {
        self.token = token
    }
    func upDateToken(token:String) {
        self.token = token
    }
}

//MARK: - 給TableView or Collection or 其他list 用的model
struct SectionTypes: RawRepresentable, Equatable {
    typealias RawValue = String
    var rawValue: String
    
    //這裡放共用的type，其餘的在各自的VM擴充
    static let empty = SectionTypes(rawValue: "empty")
}

struct RowTypes: RawRepresentable, Equatable {
    typealias RawValue = String
    var rawValue: String
    
    //這裡放共用的type，其餘的在各自的VM擴充
    static let name = RowTypes(rawValue: "name")
}

//enum ListItemSectionTypes:String {
//    case textHead
//    case iconText
//    case textWithMore
//    case iconTextWithMore
//    case empty
//    case nearBy
//    case latest
//    case dateWithYou
//    case becomeVIP
//    case goddess
//
//}
//enum ListItemRowType:String {
//    case name
//    case avater
//    case horizon_Round
//    case bigCollectionOne
//    case horizon_WaterFall
//    case twoCard
//    case ig_Cube
//    case avaterName
//    case horizon_ad
//    case goddess
//}

protocol SectionItemProtocol {
    
    var sectionType: SectionTypes { get }// key!!!!
    var value:Any? { get }
    var rows:[RowItemProtocol] { get }
    
    var tableHeaderFooter:UITableViewHeaderFooterView.Type? { get set }
    var collectionHeaderFooter:UICollectionReusableView.Type? { get set }
}

protocol RowItemProtocol {
    var rowType:RowTypes { get }// key!!!!
    var value:Any { get }
    var tableViewCell:UITableViewCell.Type? { get set }
    var collectionViewCell:UICollectionViewCell.Type? { get set }
}
