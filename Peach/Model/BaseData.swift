//
//  BaseData.swift
//  Peach
//
//  Created by dean on 2019/8/8.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation


struct BaseData<T: Codable>: Codable {
    var code: Int?
    var msg: String?
    var data: T?
}

struct BaseListData<T: Codable>: Codable {
    var code: Int?
    var msg: String?
    var data: [T]?
}

struct AnyData<T: Codable>: Codable {
    
}
