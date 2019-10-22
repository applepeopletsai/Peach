//
//  NSUserDefaultManager.swift
//  VIP
//
//  Created by dean on 2019/8/5.
//  Copyright © 2019 AwesomeGaming. All rights reserved.
//

import Foundation

protocol NSUserDefaultManagerable {
    func saveValue(value:Any,key:String)
    func getValue(key:String) -> Any?
}

struct NSUserDefaultManagerStaticKeys {
    static let password = "password"
    static let loginID = "loginID"
    static let emailAsID = "emailAsID"
    static let virtualUserKey = "virtualUserKey"
    static let userHasRegist = "userHasRegist"
    static let userLoginStatus = "userLoginStatus"
    
}

struct NSUserDefaultManager : NSUserDefaultManagerable {
    
    //Singleton
    static let shared = NSUserDefaultManager()
    /*  can also use paramater to init
     let baseURL = ""
     private int(url:String) {
     self.baseURL = url
     }
     */
    //Initialization
    private init() {
        
    }
    func saveValue(value: Any, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    func getValue(key: String) -> Any? {
        guard let value =  UserDefaults.standard.object(forKey: key) else {
            return nil
        }
        return value
    }
    func saveValues(dics:[Dictionary<String,Any>]) {
        for dic in dics {
            saveValue(value: dic.values.first as Any, key: dic.keys.first ?? "defaultKey")
        }
    }
    //註冊,登入後,
    func saveUserUnsafeData(dics:[Dictionary<String,Any>],isLogin:Bool) {
        saveValues(dics: dics)
        self.setUserLoginStatus(isLogin: isLogin)
    }
    
    //改變登入狀態(註冊時，登入時，登出時)
    func setUserLoginStatus(isLogin:Bool) {
        self.saveValue(value: isLogin, key: NSUserDefaultManagerStaticKeys.userLoginStatus)
    }
    
    //檢查是否登入，只要沒有login就是vuser
    func checkIsLogin() -> Bool {
        guard let isLogin = self.getValue(key: NSUserDefaultManagerStaticKeys.userLoginStatus) else {
            return false
        }
        return isLogin as! Bool
    }
}









