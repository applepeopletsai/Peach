//
//  FakeUserList.swift
//  Peach
//
//  Created by dean on 2019/8/28.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation

struct FakeUserList : Codable {
    let _id : String?
    let index : Int?
    let guid : String?
    let isActive : Bool?
    let balance : String?
    let picture : String?
    let age : Int?
    let eyeColor : String?
    let city : String?
    let name : FakeName?
    let company : String?
    let email : String?
    let phone : String?
    let address : String?
    let about : String?
    let registered : String?
    let latitude : String?
    let longitude : String?
    let tags : [String]?
    let range : [Int]?
    let friends : [FakeFriends]?
    let greeting : String?
    let favoriteFruit : String?
    
    enum CodingKeys: String, CodingKey {
        
        case _id = "_id"
        case index = "index"
        case guid = "guid"
        case isActive = "isActive"
        case balance = "balance"
        case picture = "picture"
        case age = "age"
        case eyeColor = "eyeColor"
        case city = "city"
        case name = "name"
        case company = "company"
        case email = "email"
        case phone = "phone"
        case address = "address"
        case about = "about"
        case registered = "registered"
        case latitude = "latitude"
        case longitude = "longitude"
        case tags = "tags"
        case range = "range"
        case friends = "friends"
        case greeting = "greeting"
        case favoriteFruit = "favoriteFruit"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        index = try values.decodeIfPresent(Int.self, forKey: .index)
        guid = try values.decodeIfPresent(String.self, forKey: .guid)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
        balance = try values.decodeIfPresent(String.self, forKey: .balance)
        picture = try values.decodeIfPresent(String.self, forKey: .picture)
        age = try values.decodeIfPresent(Int.self, forKey: .age)
        eyeColor = try values.decodeIfPresent(String.self, forKey: .eyeColor)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        name = try values.decodeIfPresent(FakeName.self, forKey: .name)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        about = try values.decodeIfPresent(String.self, forKey: .about)
        registered = try values.decodeIfPresent(String.self, forKey: .registered)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        tags = try values.decodeIfPresent([String].self, forKey: .tags)
        range = try values.decodeIfPresent([Int].self, forKey: .range)
        friends = try values.decodeIfPresent([FakeFriends].self, forKey: .friends)
        greeting = try values.decodeIfPresent(String.self, forKey: .greeting)
        favoriteFruit = try values.decodeIfPresent(String.self, forKey: .favoriteFruit)
    }
    
}

struct FakeName : Codable {
    let first : String?
    let last : String?
    
    enum CodingKeys: String, CodingKey {
        
        case first = "first"
        case last = "last"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        first = try values.decodeIfPresent(String.self, forKey: .first)
        last = try values.decodeIfPresent(String.self, forKey: .last)
    }
    
}
struct FakeFriends : Codable {
    let id : Int?
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
    
}
