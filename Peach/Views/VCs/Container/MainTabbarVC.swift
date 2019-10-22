//
//  MainTabbarVC.swift
//  Peach
//
//  Created by dean on 2019/8/5.
//  Copyright © 2019 AwesomeGaming. All rights reserved.
//

import UIKit

enum TabBarItemTag:Int {
    case index = 0              //首頁
    case search                 //搜尋
    case upload                 //上傳
    case chat                   //聊天
    case my                     //我的
    case max
}

class MainTabbarVC: UITabBarController {
    
    var childVCs = [UIViewController]() {
        didSet {
            setVCs(childVCs: childVCs)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setTabbarUIs()
    }
}

extension MainTabbarVC {
    
    func setVCs(childVCs:[UIViewController]) {
        self.viewControllers = nil
        
        self.viewControllers = childVCs
    }
    
    func creatNavController(vc: UIViewController, title: String, imageName: String) {
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName)
        addChild(CoreNavController(rootViewController: vc))
    }
    
    func setTabbarUIs() {
        //是否開啟半透明效果
        self.tabBar.tintColor = UIColor(red: CGFloat(240/255.0), green: CGFloat(180/255.0), blue: CGFloat(52/255.0), alpha: 1)//點擊
    }
    
    //MARK: - centerBtn
    private func addCenterButton() {
        let button = UIButton(type: .custom)
        button.frame.size = CGSize(width: 70, height: 70)
        button.center = self.tabBar.center
        button.center.y = UIScreen.height() - CGFloat(TAB_BAR_HEIGHT) + 15
        button.layer.cornerRadius = 35
        button.layer.masksToBounds = true
        
        button.backgroundColor = UIColor.red
        button.setTitle("NNN", for: .normal)
        self.view.addSubview(button)
        self.view.bringSubviewToFront(button)
        
        button.addTarget(self, action: #selector(didTouchCenterButton(_:)), for: .touchUpInside)
    }
    
    @objc private func didTouchCenterButton(_ sender: AnyObject) {
        self.selectedIndex = 2
    }
}
