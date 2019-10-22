//
//  Defined_BlockDelegate.swift
//  Peach
//
//  Created by dean on 2019/8/6.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation
import UIKit


protocol ClickListener {
    func didClickAt(_ view:UIView?, _ collectionView: UICollectionView?,_ tableView: UITableView?,_ indexPath: IndexPath?)
}
