//
//  TestModel.swift
//  Peach
//
//  Created by dean on 2019/8/8.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation

struct TestModel0 : Codable {
    let page : Int?
    let per_page : Int?
    let total : Int?
    let total_pages : Int?
    let userdata : [UserData]?
    
    enum CodingKeys: String, CodingKey {
        
        case page = "page"
        case per_page = "per_page"
        case total = "total"
        case total_pages = "total_pages"
        case userdata = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        per_page = try values.decodeIfPresent(Int.self, forKey: .per_page)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
        userdata = try values.decodeIfPresent([UserData].self, forKey: .userdata)
    }
    
}
struct UserData : Codable {
    let id : Int?
    let name : String?
    let pantone_value : String?
    let year : Int?
    let color : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case pantone_value = "pantone_value"
        case year = "year"
        case color = "color"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        pantone_value = try values.decodeIfPresent(String.self, forKey: .pantone_value)
        year = try values.decodeIfPresent(Int.self, forKey: .year)
        color = try values.decodeIfPresent(String.self, forKey: .color)
    }
    
}
