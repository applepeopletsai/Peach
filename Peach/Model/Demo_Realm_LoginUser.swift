//
//  UserModel.swift
//  VIP
//
//  Created by dean on 2018/6/4.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation
import RealmSwift

enum UserRole: String {
    case guest = "Guest"
    case member = "Member"
    case vip = "VIP"
}
class LoginUser:  Object, Decodable {

    @objc dynamic var id : String?
    @objc dynamic var nickName : String?
    @objc dynamic var email : String?
    @objc dynamic var avatarUrl : String?
    @objc dynamic var age = 0
    @objc dynamic var gender : String?
    @objc dynamic var score = 0
    @objc dynamic var level = 0
    @objc dynamic var follower = 0
    @objc dynamic var following = 0
    @objc dynamic var amountOfCollected = 0
    @objc dynamic var amountOfInboxMessage = 0
    let roles = List<Roles>()
    @objc dynamic var videoPlayRule : VideoPlayRule?
    @objc dynamic var registeredDate = 0
    @objc dynamic var logInDate = 0
    @objc dynamic var consequenceLogInDays = 0
    
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case nickName = "nickName"
        case email = "email"
        case avatarUrl = "avatarUrl"
        case age = "age"
        case gender = "gender"
        case score = "score"
        case level = "level"
        case follower = "follower"
        case following = "following"
        case amountOfCollected = "amountOfCollected"
        case amountOfInboxMessage = "amountOfInboxMessage"
        case roles = "roles"
        case videoPlayRule = "videoPlayRule"
        case registeredDate = "registeredDate"
        case logInDate = "logInDate"
        case consequenceLogInDays = "consequenceLogInDays"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        nickName = try values.decodeIfPresent(String.self, forKey: .nickName)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        age = try values.decode(Int.self, forKey: .age)//decodeIfPresent(Int.self, forKey: .age)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        score = try values.decode(Int.self, forKey: .score)
        level = try values.decode(Int.self, forKey: .level)
        follower = try values.decode(Int.self, forKey: .follower)
        following = try values.decode(Int.self, forKey: .following)
        amountOfCollected = try values.decode(Int.self, forKey: .amountOfCollected)
        amountOfInboxMessage = try values.decode(Int.self, forKey: .amountOfInboxMessage)
//        amountOfSelfie = try values.decode(Int.self, forKey: .amountOfSelfie)
        videoPlayRule = try values.decodeIfPresent(VideoPlayRule.self, forKey: .videoPlayRule)
//        videoPlayRule = theVideoPlayRule
        let theRoles = try values.decodeIfPresent([Roles].self, forKey: .roles) ?? [Roles()]
        roles.append(objectsIn: theRoles)
//        if let arr = try values.decodeIfPresent(Array<Roles>.self, forKey: .roles) {
//
//        } else {
//
//        }
        registeredDate = try values.decode(Int.self, forKey: .registeredDate)
        logInDate = try values.decode(Int.self, forKey: .logInDate)
        consequenceLogInDays = try values.decode(Int.self, forKey: .consequenceLogInDays)
    }

    static func ==(m1:LoginUser,m2:LoginUser) -> Bool{
        return m1.id == m2.id
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Roles : Object, Codable {
    @objc dynamic var role : String?
    @objc dynamic var beginDate = 0
    @objc dynamic var expiredDate = 0
//    let beginDate = RealmOptional<Int>()
//    let expiredDate = RealmOptional<Int>()

    
    enum CodingKeys: String, CodingKey {
        
        case role = "role"
        case beginDate = "beginDate"
        case expiredDate = "expiredDate"
    }
    override class func primaryKey() -> String? {
        return "role"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        role = try values.decodeIfPresent(String.self, forKey: .role)
        beginDate = try values.decodeIfPresent(Int.self, forKey: .beginDate) ?? 0
        expiredDate = try values.decodeIfPresent(Int.self, forKey: .expiredDate) ?? 0
    }
    
}
class VideoPlayRule : Object, Decodable {
    @objc dynamic var brandId : String?
    @objc dynamic var playDuration : PlayDuration?
    @objc dynamic var token : Token?
    @objc dynamic var lockedRule : LockedRule?
    @objc dynamic var id : String?
    
    enum CodingKeys: String, CodingKey {
        
        case brandId = "brandId"
        case playDuration = "playDuration"
        case token = "token"
        case lockedRule = "lockedRule"
        case id = "id"
    }
    override class func primaryKey() -> String? {
        return "brandId"
    }
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.brandId = try values.decode(String.self, forKey: .brandId)
        playDuration = try values.decodeIfPresent(PlayDuration.self, forKey: .playDuration)
//        playDuration.append(objectsIn: theplayDuration)
//        playDuration = try values.decodeIfPresent(PlayDuration.self, forKey: .playDuration)
        token = try values.decodeIfPresent(Token.self, forKey: .token)
//        token.append(objectsIn: theToken)
//        token = try values.decodeIfPresent(Token.self, forKey: .token)
        lockedRule = try values.decodeIfPresent(LockedRule.self, forKey: .lockedRule)
//        lockedRule.append(objectsIn: theLockedRule)
//        lockedRule = try values.decodeIfPresent(LockedRule.self, forKey: .lockedRule)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }
    
}

class Token : Object, Codable {
    @objc dynamic var tokenExpiredStart = 0
    @objc dynamic var tokenExpiredEnd = 0
    
    enum CodingKeys: String, CodingKey {
        
        case tokenExpiredStart = "tokenExpiredStart"
        case tokenExpiredEnd = "tokenExpiredEnd"
    }
    @objc dynamic var compoundKey: String = ""
    
    override class func primaryKey() -> String? { // 給 Realm 使用
        return "compoundKey"
    }
    
    private func compoundKeyValue() -> String {
        return "\(tokenExpiredStart)-\(tokenExpiredEnd)"
    }
//    convenience required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        tokenExpiredStart = try values.decode(Int.self, forKey: .tokenExpiredStart)
//        tokenExpiredEnd = try values.decode(Int.self, forKey: .tokenExpiredEnd)
//    }
    
}
class PlayDuration : Object, Codable {
    @objc dynamic var isEnable = false
    @objc dynamic var duration = 0
    @objc dynamic var start = 0
    
    enum CodingKeys: String, CodingKey {
        
        case isEnable = "isEnable"
        case duration = "duration"
        case start = "start"
    }
    @objc dynamic var compoundKey: String = ""
    
    override class func primaryKey() -> String? { // 給 Realm 使用
        return "compoundKey"
    }
    
    private func compoundKeyValue() -> String {
        return "\(isEnable)-\(duration)-\(start)"
    }
//    convenience required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        isEnable = try values.decode(Bool.self, forKey: .isEnable)
//        duration = try values.decode(Int.self, forKey: .duration)
//        start = try values.decode(Int.self, forKey: .start)
//    }
    
}
class LockedRule : Object, Codable {
    @objc dynamic var isEnable = false
    @objc dynamic var lockedTimes = 0
    @objc dynamic var lockedMode : String?
    
    enum CodingKeys: String, CodingKey {
        
        case isEnable = "isEnable"
        case lockedTimes = "lockedTimes"
        case lockedMode = "lockedMode"
    }
    @objc dynamic var compoundKey: String = ""
    
    override class func primaryKey() -> String? { // 給 Realm 使用
        return "compoundKey"
    }
    
    private func compoundKeyValue() -> String {
        return "\(isEnable)-\(lockedTimes)-\(String(describing: lockedMode))"
    }
//    convenience required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        isEnable = try values.decode(Bool.self, forKey: .isEnable)
//        lockedTimes = try values.decode(Int.self, forKey: .lockedTimes)
//        lockedMode = try values.decode(String.self, forKey: .lockedMode)
//    }
    
}
