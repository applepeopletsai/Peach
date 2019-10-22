//
//  NotificationCenter_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation

protocol NotificationKey {
    associatedtype Key: RawRepresentable
}

extension NotificationCenter: NotificationKey {
    enum Key: String {
        case DidReceiveIGAccessToken
        case CollectionTableViewCellDidClick
        case CustomChatCellDidClick
    }
}

extension NotificationKey where Self.Key.RawValue == String {
    static func addObserver(_ observer: Any, selector: Selector, key: Key, object: Any? = nil) {
        let aName = key.rawValue
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: aName), object: object)
    }
    static func postNotification(_ key: Key, object: Any? = nil, userInfo: [String : Any]? = nil) {
        let aName = key.rawValue
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: aName), object: object, userInfo: userInfo)
    }
    static func removeObserver(_ observer: Any, key: Key, object: Any? = nil) {
        let aName = key.rawValue
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: aName), object: object)
    }
    
    static func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}
