//
//  CoreTableViewCell.swift
//  Peach
//
//  Created by dean on 2019/8/7.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

class CoreTableViewCell: UITableViewCell,CellPressible {
    
    var item: RowItemProtocol?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("Generic Cell Initialization Done")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addClickListener(view:UIView) {
        view.addTapGesture(tapNumber: 1, target: self, action: #selector(didClickView(_:)))
    }
    
    var cellPressed: (() -> (Void))?
    @objc func didClickView(_ sender: Any) {
        cellPressed?()
    }
}
