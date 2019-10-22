//
//  TestAPIManager.swift
//  Peach
//
//  Created by dean on 2019/8/8.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation

enum TestAPI {
    
    struct UserList: ApiTargetType {
        
        typealias ResponseDataType = TestModel0
        
        var baseURL: URL = URL(string: "https://reqres.in/")!
        
        var path: String { return "api/users?page=2" }
        
        
        init() {
            
        }
    }
    
}
