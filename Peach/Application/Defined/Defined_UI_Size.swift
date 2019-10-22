//
//  Defined_UI.swift
//  Peach
//
//  Created by dean on 2019/8/6.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

//定義檔:
//Main Index VC
//let contentSpace:CGFloat  = 20

enum MainIndexConstants {
    
    enum tableViewHeaderHeight {
        case nearBy,latest, becomeVIP, goddess
        func getHeight() -> CGFloat {
            switch self {
            case .nearBy:
                return 40
            case .latest:
                return 60
            case .becomeVIP:
                return 60
            case .goddess:
                return 80
//            default:
//                Log.warning("Error: tableViewHeaderHeight")
//                return 0
            }
        }
    }
    enum tableViewCellHeight {
        case nearBy,latest, becomeVIP, goddess
        func getHeight() -> CGFloat {
            switch self {
            case .nearBy:
                return UIScreen.width() / 6 * 1.5 + 20
            case .latest:
                return UIScreen.height() / 3 + 20
            case .becomeVIP:
                return UIScreen.height() / 10 + 20
            case .goddess:
                return (UIScreen.height() / 3 + 20 ) * 3 + 60
//            default:
//                Log.warning("Error: tableViewCellHeight")
//                return 100
            }
        }
        
    }
    
    enum CollectionViewCellSize {
        case nearBy,latest, becomeVIP, goddess
        func getSize() -> CGSize {
            switch self {
            case .nearBy:
                return CGSize(width: UIScreen.width() / 6, height: UIScreen.width() / 6 * 1.5)
            case .latest:
                return CGSize(width: UIScreen.width() / 3, height: UIScreen.height() / 3)
            case .becomeVIP:
                return CGSize(width: UIScreen.width() * 0.7, height: UIScreen.height() / 10)
            case .goddess:
                return CGSize(width: UIScreen.width() / 2, height: UIScreen.height() / 3)
//            default:
//                Log.warning("Error: CollectionViewCellSize")
//                return CGSize(width: 100, height: 100)
            }
        }
        
    }
    enum OtherSets: CGFloat {
        case contentSpace = 20
        case cornorRadius = 10
    }
    
}
