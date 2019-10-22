//
//  IGAPIManager.swift
//  Peach
//
//  Created by Daniel on 28/08/19.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Moya

enum IGAPIManager {
    
    struct GetIGToken: ApiTargetType {
        typealias ResponseDataType = IGData

        var baseURL: URL { return URL(string: "https://api.instagram.com/v1/users")! }
        
        var path: String { return userId }
        
        var task: Task {
            return .requestParameters(parameters: ["access_token":accessToken], encoding: URLEncoding.default)
        }
        
        var userId: String
        
        var accessToken: String
        
        init(userId: String, accessToken: String) {
            self.userId = userId
            self.accessToken = accessToken
        }
    }
}
