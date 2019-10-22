//
//  JSONDecoderHelper.swift
//  BlockchainWallet_Swift
//
//  Created by Daniel on 2019/7/23.
//  Copyright © 2019 Daniel. All rights reserved.
//

import Foundation

/*
 API回傳格式
 
 //一般
 {
 "code": 200,
 "msg": "成功"
 "data": JsonObject
 }
 
 //列表
 {
 "code": 200,
 "msg": "成功"
 "data": {
            "list": JsonObject
    }
 }
 */

/*
 對應api response jsonobject的key
 若有更換key值，直接更換這裡的字串
 例如api response的'msg'變為'message'，則將ResponseKey_msg的字串由'msg'改為'message'即可
 */
private let ResponseKey_code                = "code"
private let ResponseKey_msg                 = "msg"
private let ResponseKey_data                = "data"
private let ResponseKey_list                = "list"

class JSONDecoderHelper {
    
    static func model<T: Codable>(from data: Data) throws -> T? {
        do {
            if let jsonString = String(data: data, encoding: .utf8){
                ///將字串印出
                print("JSONString = \(jsonString),\(try JSONDecoder().decode(T.self, from: data))")
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch DecodingError.keyNotFound(_, let context) {
            throw NetworkError.JsonDecodingError(context: context, model: T.self)
        } catch DecodingError.typeMismatch(_, let context) {
            throw NetworkError.JsonDecodingError(context: context, model: T.self)
        } catch DecodingError.dataCorrupted(let context) {
            throw NetworkError.JsonDecodingError(context: context, model: T.self)
        } catch DecodingError.valueNotFound(_, let context) {
            throw NetworkError.JsonDecodingError(context: context, model: T.self)
        } catch {
            throw NetworkError.DecodingError(message: error.localizedDescription)
        }
//        do {
//            return try JSONDecoder().decode(T.self, from: data)
//        } catch DecodingError.keyNotFound(let key, let context) {
//            print("KeyNotFound, key: \(key)")
//            print("CodingPath: \(context.codingPath)")
//            print("Debug description: \(context.debugDescription)")
//            return nil
//        } catch DecodingError.typeMismatch(let type, let context) {
//            print("TypeMismatch, type: \(type)")
//            print("CodingPath: \(context.codingPath)")
//            print("Debug description: \(context.debugDescription)")
//            return nil
//        } catch DecodingError.dataCorrupted(let context) {
//            print("DataCorrupted")
//            print("CodingPath: \(context.codingPath)")
//            print("Debug description: \(context.debugDescription)")
//            return nil
//        } catch DecodingError.valueNotFound(let type, let context) {
//            print("ValueNotFound, type: \(type)")
//            print("CodingPath: \(context.codingPath)")
//            print("Debug description: \(context.debugDescription)")
//            return nil
//        } catch {
//            print("Decoder Error: \(error.localizedDescription)")
//            return nil
//        }
    }
    
    static func decodeAnyModel(from data: Data,anyModel:Any) throws -> AnyObject? {
        
        if anyModel is TestModel0.Type {
            do {
                
                let model = try JSONDecoder().decode(TestModel0.self, from: data)
                return model as AnyObject
            } catch {
                throw NetworkError.JsonSerializationError(type: .SerializationJsonObjectFail(key: "response"))
            }
            
        }
        return nil
    }
    
    static func listModel<T: Codable>(from data: Data, keyPath: String? = ResponseKey_list) throws -> BaseListData<T>? {
        if let keyPath = keyPath {
            do {
                //response dic
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                var baseListModel: BaseListData<T> = BaseListData<T>(code: -1, msg: "", data: nil)
                
                //response[ResponseKey_code]
                if let code = jsonObject?.object(forKey: ResponseKey_code) as? Int {
                    baseListModel.code = code
                } else {
                    throw NetworkError.JsonSerializationError(type: .KeyNotFound(key: "response[\(ResponseKey_code)]"))
                }
                
                //response[ResponseKey_msg]
                if let msg = jsonObject?.object(forKey: ResponseKey_msg) as? String {
                    baseListModel.msg = msg
                } else {
                    throw NetworkError.JsonSerializationError(type: .KeyNotFound(key: "response[\(ResponseKey_msg)]"))
                }
                
                //response[ResponseKey_data]
                if let dataDic = jsonObject?.object(forKey: ResponseKey_data) as? NSDictionary {
                    
                    //response[ResponseKey_data][keyPath]
                    if let listDic = dataDic.object(forKey: keyPath) {
                        do {
                            let listData = try JSONSerialization.data(withJSONObject: listDic)
                            do {
                                baseListModel.data = try self.model(from: listData)
                            } catch {
                                throw error as! NetworkError
                            }
                            return baseListModel
                        } catch {
                            throw NetworkError.JsonSerializationError(type: .SerializationDataFail(key: "response[\(ResponseKey_data)][\(keyPath)]"))
                        }
                    } else {
                        throw NetworkError.JsonSerializationError(type: .KeyNotFound(key: "response[\(ResponseKey_data)][\(keyPath)]"))
                    }
                } else {
                    throw NetworkError.JsonSerializationError(type: .KeyNotFound(key: "response[\(ResponseKey_data)]"))
                }
            } catch {
                throw NetworkError.JsonSerializationError(type: .SerializationJsonObjectFail(key: "response"))
            }
        } else {
            return nil
        }
    }
}
