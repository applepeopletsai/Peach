//
//  Bundle_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit

extension Bundle {
    //取得app icon
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
    //    public var appVersion: String? {
    //        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    //    }
    
    static var appVersion: String? {
        return self.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    static var camaraPermisionAlertMsg: String? {
        return self.main.object(forInfoDictionaryKey: "NSCameraUsageDescription") as? String
    }
    static var photoPermisionAlertMsg: String? {
        return self.main.object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription") as? String
    }
    static func jsonReader(fileName:String) -> Data? {
        if let path = self.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                return data
            } catch {
                // handle error
                Log.error("jsonReader Error")
                return nil
            }
        }
        return nil
    }
}
