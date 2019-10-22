//
//  DomainData.swift
//  BlockchainWallet_Swift
//
//  Created by Daniel on 2019/7/30.
//  Copyright © 2019 Daniel. All rights reserved.
//

import Foundation

class DomainData: Codable {
    
    class Data: Codable {
        var domain: String
    }
    
    var apiDomain: [Data]
    var pictureDomain: [Data]
    var domainVersion: Int
    
    enum CodingKeys: String, CodingKey {
        case apiDomain = "api_domain"
        case pictureDomain = "picture_domain"
        case domainVersion = "domain_version"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.apiDomain = []
        self.pictureDomain = []
        self.domainVersion = NSNotFound
        
        if let apiDomain = try container.decodeIfPresent([Data].self, forKey: .apiDomain) {
            self.apiDomain = apiDomain
        }
        if let pictureDomain = try container.decodeIfPresent([Data].self, forKey: .pictureDomain) {
            self.pictureDomain = pictureDomain
        }
        if let domainVersion = try container.decodeIfPresent(Int.self, forKey: .domainVersion) {
            self.domainVersion = domainVersion
        }
    }
}
