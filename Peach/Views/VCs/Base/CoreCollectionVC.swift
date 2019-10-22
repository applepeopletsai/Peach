//
//  CoreCollectionVC.swift
//  Peach
//
//  Created by dean on 2019/8/23.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class CoreCollectionVC: CoreVC {
    
    //Default CollectionView
    lazy var collectionLazyView: UICollectionView = {
        
        let collectionLazyView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - CGFloat(NAVIGATION_BAR_HEIGHT)), collectionViewLayout: UICollectionViewFlowLayout())
        collectionLazyView.backgroundColor = .white
        return collectionLazyView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setCollectionView(collectionView:UICollectionView,layout:UICollectionViewLayout) {
        collectionView.collectionViewLayout = layout
        
        collectionView.dataSource = self
        //註冊items 裡面的 cells 所以一切在model形成就定義好
        var cellArr = [UICollectionViewCell.Type]()
        var headerArr = [UICollectionReusableView.Type]()
        if let items = viewModel?.items {
            //Section
            for sectionItem in items {
                //註冊header, footer
                if let header = sectionItem.collectionHeaderFooter {
                    
                    if headerArr.contains(where: { $0 == header }) {
                        // found
                    } else {
                        // not
                        headerArr.append(header)
                    }
                }
                //Row
                for row in sectionItem.rows {
                    if let cell = row.collectionViewCell {
                        
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
        
        //register header and cells
        collectionView.register(reusableViewTypes: headerArr)
        collectionView.register(cellTypes: cellArr)
        
    }
    

}

extension CoreCollectionVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.items?[section].rows.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let item = self.viewModel?.items?[indexPath.section].rows[indexPath.row] {
            let cell = collectionView.dequeueReusableCell(with: item.collectionViewCell ?? UICollectionViewCell.self, for: indexPath)
            
            if cell.isKind(of: CoreCollectionViewCell.self) {
                let cell = cell as? CoreCollectionViewCell
                cell?.item = item
            }
            return cell
        }
        
        return UICollectionViewCell(frame: .zero)
    }
    
    
}
