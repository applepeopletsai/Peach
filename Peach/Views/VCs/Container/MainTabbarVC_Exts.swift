//
//  MainTabbarVC_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/5.
//  Copyright © 2019 AwesomeGaming. All rights reserved.
//

import Foundation
import UIKit


extension MainTabbarVC : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController), index == 2 {
            if let currentNaviVC = tabBarController.viewControllers?[tabBarController.selectedIndex] as? UINavigationController {
                UploadPostRouter().route(to: UploadPostRouterID.selectAsset.rawValue, from: currentNaviVC, parameters: nil)
            }
            return false
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //        print(viewController)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        guard let index = tabBar.items?.index(of: item) else { return }
        
        tabBar.tintColor = UIColor(red: CGFloat(240/255.0), green: CGFloat(180/255.0), blue: CGFloat(52/255.0), alpha: 1)
    }
    
}
