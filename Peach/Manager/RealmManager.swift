//
//  RealmManager.swift
//  VIP
//
//  Created by dean on 2019/8/5.
//  Copyright © 2019 AwesomeGaming. All rights reserved.
//

import Foundation
import RealmSwift


class RealmManager: NSObject {
    //Singleton
    static let shared = RealmManager()
    /*  can also use paramater to init
     let baseURL = ""
     private int(url:String) {
     self.baseURL = url
     }
     */
    //Initialization
    private override init() {
        
    }
    
    func setDefaultRealm() {
        
//        var config = Realm.Configuration(
//            schemaVersion: 0,
//            migrationBlock: { _, _ in
//                // list migration changes here
//
//        })
        let userLoginStatus = NSUserDefaultManager.shared.checkIsLogin()
        if userLoginStatus {
            if let userID = NSUserDefaultManager.shared.getValue(key: NSUserDefaultManagerStaticKeys.emailAsID) {
                setDefaultRealmForUser(username: userID as! String)
                
            } else {
                setDefaultRealmForUser(username: NSUserDefaultManagerStaticKeys.virtualUserKey)
            }
        } else {
            setDefaultRealmForUser(username: NSUserDefaultManagerStaticKeys.virtualUserKey)
        }
        
        
        
    }
    func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration()
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(username).realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
        print("RealmFilePath: \(Realm.Configuration.defaultConfiguration.fileURL!)")
    }
    
    
}
extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}



















































