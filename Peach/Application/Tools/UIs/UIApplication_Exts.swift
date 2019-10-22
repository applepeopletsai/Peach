//
//  UIApplication_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications
import Photos
import CoreLocation

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
    func topMostViewController() -> UIViewController? {
        return keyWindow?.rootViewController?.topMostViewController()
    }
    //MARK: - User Permission(獲取使用者同意權限)
    //=====  相機權限  =====
    func checkPermissionToCamera(granted: @escaping (() -> Void)) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
            
            if status == .authorized {
                granted()
            } else if status == .denied {
                self.showDefaultUserPermissionAlert(title: "permission_CamaraTitle".localized, content: "permission_CamaraContent".localized, actionTitle: "permission_CamaraGoToSetting".localized)
            } else if status == .notDetermined {
                
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (accessAllowed) in
                    if accessAllowed {
                        granted()
                    } else {
                        self.showDefaultUserPermissionAlert(title: "permission_CamaraTitle".localized, content: "permission_CamaraContent".localized, actionTitle: "permission_CamaraGoToSetting".localized)
                    }
                })
            } else if status == .restricted {
                self.showDefaultUserPermissionAlert(title: "permission_CamaraTitle".localized, content: "permission_CamaraContent".localized, actionTitle: "permission_CamaraGoToSetting".localized)
            }
        } else {
            print("Camera not available on this device")
        }
    }
    //=====  請求使用相簿權限  =====
    func checkPhotoAuthorize() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization({ (_) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    _ = self.checkPhotoAuthorize()
                })
            })
        default:
            self.showDefaultUserPermissionAlert(title: "permission_PhotoTitle".localized, content: "permission_PhotoContent".localized, actionTitle: "permission_PhotoGoToSetting".localized)
            
        }
        return false
    }
    //=====  位置權限狀態  =====
    func checkLocationPermission() {
        LocationManager.shared.checkLocationPermision()
    }
    
    //=====  通知權限  =====
    func isNotificationEnabled(completion:@escaping (_ notificationCenter:UNUserNotificationCenter,_ enabled:Bool)->()){
        if #available(iOS 10, *)
        { // iOS 10 support
            //create the notificationCenter
            let center = UNUserNotificationCenter.current()
            // set the type as sound or badge
            center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
                if granted {
                    print("Notification Enable Successfully")
                }else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.showDefaultUserPermissionAlert(title: "permission_NotificationTitle".localized, content: "permission_NotificationContent".localized, actionTitle: "permission_NotificationGoToSetting".localized)
                    })
                    
                }
            }
            self.registerForRemoteNotifications()
        }
        else
        {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            self.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        
    }
    
    //show default Alert
    func showDefaultUserPermissionAlert(title:String,content:String,actionTitle:String) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        if let vc = self.topMostViewController() {
            vc.present(alert, animated: true, completion: nil)
        }
        
        
    }
}
