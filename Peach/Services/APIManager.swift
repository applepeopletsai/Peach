//
//  APIManager.swift
//  BlockchainWallet_Swift
//
//  Created by Daniel on 2019/6/6.
//  Copyright © 2019 Daniel. All rights reserved.
//

import Moya
import Alamofire

/// 預先指定response的data type
protocol DecodableResponseTargetType: TargetType {
    associatedtype ResponseDataType: Codable
}

/// API的共用protocol，設定API共用參數，且api的response皆要可以被decode
protocol ApiTargetType: DecodableResponseTargetType {}

/// 設定API的共用(預設)參數
extension ApiTargetType {
    var baseURL: URL { return URL(string: ApiUrl.currentDoamin())! }
    
    var path: String { return "" }
    
    var method: Alamofire.HTTPMethod { return .get }
    
    var headers: [String : String]? {
        /* 沒用到，先包起來
         var h: [String:String] = ["Authorization":GlobalData.shared.token]
         switch task {
         case .requestParameters(let p, _):
         //將參數加簽後放到Header中
         h.merge(self.parametersEncryption(p), uniquingKeysWith: { $1 })
         default: break
         }
         
         return h
         */
        return nil
    }
    
    var task: Task { return .requestPlain }
    
    var paramaters: HTTPParamaters? { return nil }
    
    var sampleData: Data { return Data() }
    
    var timeoutInterval: TimeInterval { return defaultTimeoutInterval }

    var page: Int { return 1 }
    
    var limit: Int { return 10 }
    
    /// 參數加簽
    ///
    /// - Parameter parameters: Request的Parameters
    /// - Returns: 加簽後的Headers
    private func parametersEncryption(_ parameters: [String:Any]) -> [String:String] {
        let urlPath = "\(self.baseURL.path)/\(self.path)"
        let randomString = String(Int.random(in: 0..<Int.max))
        let tempTime = "\(Int(Date().timeIntervalSince1970))000"
        
        let key_XAuthKey = "X-Auth-Key"
        let key_XAuthTimeStamp = "X-Auth-TimeStamp"
        let key_XAuthNonce = "X-Auth-Nonce"
        let key_SystemCode = "systemCode"
        let key_XAuthSign = "X-Auth-Sign"
        let uuid = "12345678-C258-48BB-AC00-2C31B33706FE"
        
        var parametersDic = parameters
        parametersDic[key_XAuthKey] = kSignAppKey
        parametersDic[key_XAuthTimeStamp] = tempTime
        parametersDic[key_XAuthNonce] = randomString
        parametersDic[key_SystemCode] = uuid
        parametersDic[key_XAuthKey] = kSignAppKey
        
        var allKeyArray = Array(parametersDic.keys)
        
        allKeyArray = allKeyArray.sorted(by: { (str1, str2) -> Bool in
            let result = str1.compare(str2, options: .caseInsensitive, range: Range(NSRange(location: 0, length: str1.count), in: str1), locale: nil)
            return result == .orderedAscending
        })
        
        var unsignString = "\(self.method.rawValue)\(urlPath)?"
        for key in allKeyArray {
            let value = parametersDic[key] ?? ""
            
            if allKeyArray.firstIndex(of: key) == 0 {
                unsignString += "\(key)=\(value)"
            } else {
                unsignString += "&\(key)=\(value)"
            }
        }
        print("準備簽名的字串: \(unsignString)")
        
        let singString = unsignString.hmac(algorithm: .SHA1, key: kSignSecret)
        print("簽名後的字串: \(singString)")
        
        let urlEncodeString = singString.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!@#$%&*()+'\";:=,/?[] ").inverted)!
        print("url編碼後的字串: \(urlEncodeString)")
        
        let result: [String: String] = [key_XAuthTimeStamp:tempTime,
                                        key_XAuthNonce:randomString,
                                        key_XAuthKey:kSignAppKey,
                                        key_SystemCode:uuid,
                                        key_XAuthSign:urlEncodeString]
        return result
    }
}

struct ApiUrl {
    static func currentDoamin() -> String {
//        let alpha = "http://10.10.10.68/api/v1/"
//        let stage = "http://119.28.43.18/api/v1/"
//
//        #if ALPHA
//        return alpha
//        #else
//        return stage
//        #endif
        return DomainAPIManager.shared.currentApiDomain
    }
}
