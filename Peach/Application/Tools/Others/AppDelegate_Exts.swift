//
//  AppDelegate_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

extension AppDelegate {
    func getUserLanguage() -> String? {
        
        let userLanguate = Locale.preferredLanguages[0]
        var lan = ""
        if userLanguate.range(of: "zh-Hans") != nil {
            //簡體
            lan = "zh-CN"
        } else if userLanguate.range(of: "zh-Hant") != nil {
            //繁體
            lan = "zh-TW"
        } else if userLanguate.range(of: "en") != nil {
            //英文
            lan = "en-US"
        } else {
            //預設簡體
            lan = "zh-CN"
        }
        
        return lan
        
    }
    
    func getUserUDID() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
}
