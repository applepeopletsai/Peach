//
//  CoreTableVC.swift
//  Peach
//
//  Created by dean on 2019/8/23.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class CoreTableVC: CoreVC {
    
    lazy var tableLazyView: UITableView = {
        let tableV = UITableView(frame: CGRect(x: 0, y: CGFloat(NAVIGATION_BAR_HEIGHT), width: screenWidth, height: screenHeight - CGFloat(NAVIGATION_BAR_HEIGHT)), style: .plain)
        tableV.estimatedRowHeight = 100.0
        tableV.rowHeight = UITableView.automaticDimension
        tableV.tableFooterView = UIView()
        return tableV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //do this after viewModel's item set already, because of dataSource
    func setTableView(tableView:UITableView?) {
        tableView?.dataSource = self
        tableView?.estimatedRowHeight = 44.0
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.tableFooterView = UIView()
        //註冊items 裡面的 cells 所以一切在model形成就定義好
        var cellArr = [UITableViewCell.Type]()
        var headerArr = [UITableViewHeaderFooterView.Type]()
        if let items = viewModel?.items {
            //Section
            for sectionItem in items {
                //註冊header, footer
                if let header = sectionItem.tableHeaderFooter {
                    
                    if headerArr.contains(where: { $0 == header }) {
                        // found
                    } else {
                        // not
                        headerArr.append(header)
                    }
                }
            //Row
                for row in sectionItem.rows {
                    if let cell = row.tableViewCell {
                        
                        if cellArr.contains(where: { $0 == cell }) {
                            // found
                        } else {
                            // not
                            cellArr.append(cell)
                        }
                        
                    }
                }
                
            }
        }
        
        for header in headerArr {
            tableView?.registerHeaderFooterViewNib(header)
        }
        for cell in cellArr {
            tableView?.registerCellNib(cell)
        }
    }
    
    func registCells() {}
}

extension CoreTableVC :UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.items?.count ?? 0
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.items?[section].rows.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = self.viewModel?.items?[indexPath.section].rows[indexPath.row] {
            let cell = tableView.dequeueReusableCell(with: item.tableViewCell ?? UITableViewCell.self, for: indexPath)
            if cell.isKind(of: CoreTableViewCell.self) {
                let cell = cell as? CoreTableViewCell
                cell?.item = item
            }
            return cell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
    }
    
}
