//
//  IGData.swift
//  Peach
//
//  Created by Daniel on 28/08/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation

class IGData: Codable {
    
    var userId: String?
    var userName: String?
    var pictureURL: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case userName = "full_name"
        case pictureURL = "profile_picture"
    }
}
