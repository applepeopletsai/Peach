//
//  CoreNavController.swift
//  Peach
//
//  Created by dean on 2019/8/13.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

enum NavigationItemType {
    case back_Img
    case back_Title
}

class CoreNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        navigationBar.barTintColor = UIColor.white
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
}
