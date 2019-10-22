//
//  LaunchLoginRouter.swift
//  Peach
//
//  Created by dean on 2019/8/6.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit


enum LaunchLoginRouteID:String {
    case preferenceUnset                //case 1 : 取得會員資料：會員尚未設定偏好，進入偏好設定流程
    case preferenceSettingComplete      //case 2 : 取得會員資料：會員尚已設定偏好，進入首頁
}

class LaunchLoginRouter: Router {
    
    var viewModel:CoreVC?
    
    init() {}
    
    init(viewModel:CoreVC) {
        self.viewModel = viewModel
    }
    
    //MARK: Inherited Function
    func route(to routeID: String, from context: UIViewController, parameters: Any?) {
        switch routeID {
        case LaunchLoginRouteID.preferenceSettingComplete.rawValue:
            let tabbarVC = MainTabbarVC()
            tabbarVC.selectedIndex = 0
            tabbarVC.childVCs = generateAllTabbarChilds()
            tabbarVC.modalPresentationStyle = .fullScreen
            context.present(tabbarVC, animated: false, completion: nil)
        default:
            Log.debug(self)
        }
    }
}

extension LaunchLoginRouter {
    
    func generateAllTabbarChilds() -> [UIViewController] {
        var vcArr = [UIViewController]()

        var imageNormal:UIImage? = nil
        var imageSelected:UIImage? = nil
        let title:String? = nil
        
        let classViewController:UIViewController.Type = UIViewController.self
        
        var stringURL:String = ""
        
        for i in 0 ..< TabBarItemTag.max.rawValue{
            
            var viewController:UIViewController? = nil
            
            stringURL = ""
            
            if i == TabBarItemTag.index.rawValue{
                //首頁
                viewController = MainWebViewController()
                
                imageNormal = UIImage(named: "icon_home")
                imageNormal = imageNormal?.reSizeImage(reSize: CGSize(width: 30, height: 30))
                imageSelected = UIImage(named: "icon_home_tapped")?.reSizeImage(reSize: CGSize(width: 30, height: 30))
                
                stringURL = "http://119.28.43.18:8081/#/"
                
            }else if i == TabBarItemTag.search.rawValue{
                //搜尋
                viewController = MainWebViewController()
                
                imageNormal = UIImage(named: "icon_search")?.reSizeImage(reSize: CGSize(width: 30, height: 30))
                imageSelected = UIImage(named: "icon_search_tapped")?.reSizeImage(reSize: CGSize(width: 30, height: 30))
                
                stringURL = "https://web.niub88.io"

            }else if i == TabBarItemTag.upload.rawValue{
                //上傳圖片/照片
//                viewController = SelectAssetViewController()
//                classViewController = SelectAssetViewController.self
                viewController = UIViewController()

                imageNormal = UIImage(named: "btn_peach")?.reSizeImage(reSize: CGSize(width: 30, height: 30))
                imageSelected = UIImage(named: "btn_peach")?.reSizeImage(reSize: CGSize(width: 30, height: 30))
            }else if i == TabBarItemTag.chat.rawValue{
                //聊天
                viewController = MainWebViewController()
//                viewController = MultiCropperViewController(nibName: "MultiCropperViewController", bundle: nil)
                
                
                imageNormal = UIImage(named: "icon_chat")?.reSizeImage(reSize: CGSize(width: 30, height: 30))
                imageSelected = UIImage(named: "icon_chat_tapped")?.reSizeImage(reSize: CGSize(width: 30, height: 30))
                
                stringURL = "https://www.google.com.tw/"

            }else if i == TabBarItemTag.my.rawValue{
                //我的
                
                
                viewController = MainWebViewController()

                imageNormal = UIImage(named: "icon_mine")?.reSizeImage(reSize: CGSize(width: 30, height: 30))
                imageSelected = UIImage(named: "icon_mine_tapped")?.reSizeImage(reSize: CGSize(width: 30, height: 30))
                
                stringURL = "http://119.28.43.18:8081/#/"
            }
            
            imageNormal = imageNormal?.withRenderingMode(.alwaysOriginal)
            imageSelected = imageSelected?.withRenderingMode(.alwaysOriginal)
            
            let nibName = String(describing: classViewController)
            if viewController == nil{
                viewController = classViewController.init(nibName: nibName, bundle: nil)
            } else{
                if let advViewController = viewController as? MainWebViewController{
                    Log.debug("i = \(i), stringURL = \(stringURL)")
                    advViewController.loadWebView(withStringURL: stringURL)
                }
            }
            
            if let viewController = viewController{
                let navigationController:UINavigationController = CoreNavController(rootViewController: viewController)
                navigationController.tabBarItem = UITabBarItem(title: title, image: imageNormal, selectedImage: imageSelected)
                vcArr.append(navigationController)
            }
        }
        return vcArr
    }
}
