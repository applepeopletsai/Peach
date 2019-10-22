//
//  UIViewController_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return presentedViewController!.topMostViewController()
    }
    @objc func navigationBackAction() {
        
        navigationController!.popViewController(animated: true)
    }
    func showDefaultAlert(title: String, message: String,okBtnTitle: String,cancelBtnTitle: String?, complention: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: okBtnTitle,
            style: .default,
            handler: {
                (_: UIAlertAction!) -> Void in
                DispatchQueue.main.async {
                    complention()
                }
        }
        )
        alertController.addAction(okAction)
        if cancelBtnTitle != nil {
            alertController.addAction(UIAlertAction(title: cancelBtnTitle, style: .cancel, handler: nil))
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    // 這邊要% 2 因為回傳是Pixel
    var screenWidth : CGFloat {
        get {
            return UIScreen.main.nativeBounds.width / 2
        }
    }
    var screenHeight : CGFloat {
        get {
            return UIScreen.main.nativeBounds.height / 2
        }
    }
    //分享功能
    @objc func presentActivityController(content:[Any]) {
        let activityVC = UIActivityViewController(activityItems: content, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            // 如果錯誤存在，跳出錯誤視窗並顯示給使用者。
            if error != nil {
                
                return
            }
            
            // 如果發送成功，跳出提示視窗顯示成功。
            if completed {
                
            }
            
        }
        
        self.present(activityVC, animated: true, completion: nil)
    }
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @objc func dismissVC() {
        if self.presentingViewController != nil {
            if self.navigationController != nil, self.navigationController?.viewControllers.count != 1 {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func takeQRCodeScreenShot(vc:UIViewController) -> UIImage? {
        
        return vc.view.takeCustomQRCodeScreenshot(shouldSave: true)
    }
    //Navigation
    func addCustomBackBtn(withTitle title:String? = nil) {
        let customBtn = UIBarButtonItem(customView: NavItem_imageBack.instantiate())
        customBtn.customView?.backgroundColor = UIColor.clear
        customBtn.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigationBackAction)))
        
        if let customView = customBtn.customView as? NavItem_imageBack{
            customView.titleLabel.text = title;
        }
        
        self.navigationItem.leftBarButtonItem = customBtn//rightBarButtonItems = [rightBtn]
    }
    func addImageBackBtn() {
        
        let backButton = UIButton.init(type: .custom)
        backButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        // negative space
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -22.0, bottom: 0, right: 0)
        backButton.setImage(UIImage(named: "icon_arrow_left")?.scaleImage(scaleSize: 1.5), for: .normal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(navigationBackAction), for: .touchUpInside)
        
    }
    func addNavBackWithArrow(color:UIColor) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = color
    }
    
    func addCustomBackNaviItem(with title: String? = "naviBar_1".localized) {
        let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(navigationBackAction))
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.customColor(.color_text_2),
                                     NSAttributedString.Key.font:UIFont.customFont(.font_title_sbig_thin)], for: .normal)
        self.navigationItem.leftBarButtonItem = item
    }
    
    func addCustomLeftNaviItem(with title: String, textColor: UIColor = UIColor.customColor(.color_text_2), actionHandler: @escaping ActionHandler) {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        b.setTitle(title, for: .normal)
        b.setTitleColor(textColor, for: .normal)
        b.titleLabel?.font = UIFont.customFont(.font_title_sbig_thin)
        b.addAction {
            actionHandler()
        }
        let item = UIBarButtonItem(customView: b)
        self.navigationItem.leftBarButtonItem = item
    }
    
    func addCustomRightNaviItem(with title: String? = "preferenceSetting_1".localized, textColor: UIColor = UIColor.customColor(.color_text_2), actionHandler: @escaping ActionHandler) {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        b.setTitle(title, for: .normal)
        b.setTitleColor(textColor, for: .normal)
        b.titleLabel?.font = UIFont.customFont(.font_title_sbig_thin)
        b.addAction {
            actionHandler()
        }
        let item = UIBarButtonItem(customView: b)
        self.navigationItem.rightBarButtonItem = item
    }
    
    func removeLeftNaviItem() {
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func removeRightNaviItem() {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    //增加右邊的item，藉由手勢來觸發block，達成callback
    func addCustomView(vc:UIViewController, customView:UIView, completion: @escaping () -> ()) {
        let customBtn = UIBarButtonItem(customView: customView)
        customBtn.customView?.backgroundColor = UIColor.clear
        customBtn.customView?.addGestureRecognizer(UITapGestureRecognizer(target: vc, action: #selector(vc.navigationRightBtnAction(sender:))))
        viewPressed = {
            completion()
        }
        self.navigationItem.rightBarButtonItem = customBtn
        
    }
    @objc func navigationRightBtnAction(sender:Any) {
        viewPressed?()
    }
    
    func gotoSetting() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
}
