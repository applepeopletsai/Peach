//
//  TableViewModel.swift
//  Peach
//
//  Created by dean on 2019/8/6.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation
import UIKit

class TableViewModel: BaseVM {}

//MARK: - TableView DataSource
extension TableViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?[section].rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let item = items?[indexPath.section].rows[indexPath.row] {
            let cell = tableView.dequeueReusableCell(with: item.tableViewCell ?? UITableViewCell.self, for: indexPath)
            if cell.isKind(of: CoreTableViewCell.self) {
                let cell = cell as? CoreTableViewCell
                cell?.item = item
            }
            return cell
        }
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        return cell
    }
}



