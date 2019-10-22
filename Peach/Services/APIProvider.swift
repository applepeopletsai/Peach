//
//  APIProvider.swift
//  BlockchainWallet_Swift
//
//  Created by Daniel on 2019/7/23.
//  Copyright © 2019 Daniel. All rights reserved.
//

import Moya
import Alamofire

/// api的回調block，其中data為非陣列
typealias ApiCompletionBlock<T: Codable> = (BaseData<T>?, NetworkError?) -> Void

/// api的回調block，其中data為陣列
typealias ApiCompletionListBlock<T: Codable> = (BaseListData<T>?, NetworkError?) -> Void

/// api的回調block，其中data為任意型態model
typealias ApiCompletionAnyObjBlock<T: Codable> = (AnyObject?, NetworkError?) -> Void

/// api的回調block，回傳T.ResponseDataType
typealias specialRequestBlock<T: ApiTargetType> = (T.ResponseDataType?, NetworkError?) -> Void

typealias API = APIProvider
final class APIProvider {
    
    //MARK: Public Function
    
    /// API Request(回傳data為非陣列)
    ///
    /// - Parameters:
    ///   - request: ApiTargetType，遵從Moya的TargetType
    ///   - progress: 處理進度(預設為nil，若不需要可不用傳入)
    ///   - completion: api回調(data非陣列)
    static func requestData<Request: ApiTargetType>(request: Request,
                                                    progress: ProgressBlock? = nil,
                                                    completion: @escaping ApiCompletionBlock<Request.ResponseDataType>) {
        self.handleCompletion(request: request, progress: progress, apiCompletionBlock: completion, apiCompletionListBlock: nil, apiCompletionAnyObjBlock: nil)
    }
    
    /// API Request(回傳data為陣列)
    ///
    /// - Parameters:
    ///   - request: ApiTargetType，遵從Moya的TargetType
    ///   - progress: 處理進度(預設為nil，若不需要可不用傳入)
    ///   - completion: api回調(data為陣列)
    static func requestDataList<Request: ApiTargetType>(request: Request,
                                                        progress: ProgressBlock? = nil,
                                                        completion: @escaping ApiCompletionListBlock<Request.ResponseDataType>) {
        self.handleCompletion(request: request, progress: progress, apiCompletionBlock: nil, apiCompletionListBlock: completion, apiCompletionAnyObjBlock: nil)
    }
    
    /// API Request(回傳data為任意物件)
    ///
    /// - Parameters:
    ///   - request: ApiTargetType，遵從Moya的TargetType
    ///   - progress: 處理進度(預設為nil，若不需要可不用傳入)
    ///   - completion: api回調(data為任意物件)
    static func requestAnyObjList<Request: ApiTargetType>(request: Request,
                                                          progress: ProgressBlock? = nil,
                                                          completion: @escaping ApiCompletionAnyObjBlock<Request.ResponseDataType>) {
        
        self.handleCompletion(request: request, progress: progress, apiCompletionBlock: nil, apiCompletionListBlock: nil, apiCompletionAnyObjBlock: completion)
    }
    
    
    /// 依照keys解析response並轉成對應model
    ///
    /// - Parameters:
    ///   - request: ApiTargetType，遵從Moya的TargetType
    ///   - progress: 處理進度(預設為nil，若不需要可不用傳入)
    ///   - keys: 解析的key值
    ///   - completion: api回調
    static func specialRequestl<T: ApiTargetType>(request: T,
                                                  progress: ProgressBlock? = nil,
                                                  keys: [String],
                                                  completion: @escaping specialRequestBlock<T>) {
        let provider = self.createProvider(request)
        
        DispatchQueue.global().async {
            _ = provider.request(request, callbackQueue: DispatchQueue.global(), completion: { result in
                
                switch result {
                case .success(let response):
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as? NSDictionary
                        
                        var keyPath = "response"
                        if var dataDic = jsonObject {
                            for (index, key) in keys.enumerated() {
                                if index != keys.count - 1, let newDic = dicForKey(dic: dataDic, key: key) {
                                    keyPath.append("[\(key)]")
                                    dataDic = newDic
                                }
                            }
                            
                            do {
                                let data = try JSONSerialization.data(withJSONObject: dataDic)
                                do {
                                    let model: T.ResponseDataType? = try JSONDecoderHelper.model(from: data)
                                    completion(model,nil)
                                } catch {
                                    completion(nil,error as? NetworkError)
                                }
                            } catch {
                                completion(nil,NetworkError.JsonSerializationError(type: .SerializationJsonObjectFail(key: "response[\(keyPath)]")))
                            }
                        }
                    } catch {
                        completion(nil,NetworkError.JsonSerializationError(type: .SerializationJsonObjectFail(key: "response")))
                    }
                    break
                case .failure(let error):
                    let e = NetworkError.ServerErrorResponse(message: error.localizedDescription, code: error.errorCode)
                    completion(nil, e)
                    break
                }
            })
        }
    }
    
    fileprivate static func dicForKey(dic: NSDictionary, key: String) -> NSDictionary? {
        return dic.object(forKey: key) as? NSDictionary
    }
    
    //MARK: Private Function
    
    ///統一處理API
    fileprivate static func handleCompletion<Request: ApiTargetType>(request: Request, progress: ProgressBlock?, apiCompletionBlock: ApiCompletionBlock<Request.ResponseDataType>?, apiCompletionListBlock: ApiCompletionListBlock<Request.ResponseDataType>?, apiCompletionAnyObjBlock: ApiCompletionAnyObjBlock<Request.ResponseDataType>?) {
        
        let provider = self.createProvider(request)
        
        DispatchQueue.global().async {
            _ = provider.request(request, callbackQueue: DispatchQueue.global(), progress: progress, completion: { (result) in
                switch result {
                case .success(let response):
                    do {
                        let successResponse = try response.filterSuccessfulStatusCodes()
                        
                        do {
                            if let apiCompletionBlock = apiCompletionBlock {
                                let model: BaseData<Request.ResponseDataType>? = try JSONDecoderHelper.model(from: successResponse.data)
                                apiCompletionBlock(model,nil)
                            } else if let apiCompletionListBlock = apiCompletionListBlock {
                                let model: BaseListData<Request.ResponseDataType>? = try JSONDecoderHelper.listModel(from: successResponse.data)
                                apiCompletionListBlock(model,nil)
                            } else if let apiCompletionAnyObjBlock = apiCompletionAnyObjBlock {
                                
                                let model = try JSONDecoderHelper.decodeAnyModel(from: successResponse.data, anyModel: TestModel0.self)
                                
                                apiCompletionAnyObjBlock(model,nil)
                            }
                        } catch {
                            let e = error as! NetworkError
                            print(e.message)
                            apiCompletionBlock?(nil,e)
                            apiCompletionListBlock?(nil,e)
                        }
                    } catch {
                        let e = NetworkError.HttpStatusCodeError(message: error.localizedDescription, code: response.statusCode)
                        print(e.message)
                        apiCompletionBlock?(nil, e)
                        apiCompletionListBlock?(nil, e)
                    }
                    break
                case .failure(let error):
                    let e = NetworkError.ServerErrorResponse(message: error.localizedDescription, code: error.errorCode)
                    print(e.message)
                    apiCompletionBlock?(nil, e)
                    break
                }
            })
        }
    }
    
    ///自定義MoyaProvider
    fileprivate static func createProvider<T: ApiTargetType>(_ type: T) -> MoyaProvider<T> {
        
        let endpointClosure = { (target: T) -> Endpoint in
            let url = (target.path.count == 0) ? target.baseURL.absoluteString : target.baseURL.appendingPathComponent(target.path).absoluteString
            let endPoint: Endpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
            return endPoint
        }
        
        return MoyaProvider<T>(endpointClosure: endpointClosure, manager: CustomSessionManager.getManager(request: type), plugins: [logger])
    }
    
    ///自定義NetworkLoggerPlugin
    fileprivate static let logger = NetworkLoggerPlugin(verbose: true, responseDataFormatter: { (data: Data) -> Data in
        //轉成PrettyPrinted
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data
        }
    })
}

fileprivate final class CustomSessionManager: Manager {
    
    private static let sharedManager: Manager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = defaultTimeoutInterval
        
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        return manager
    }()
    
    static func getManager<Request: ApiTargetType>(request: Request) -> SessionManager {
        if request.timeoutInterval == defaultTimeoutInterval {
            return self.sharedManager
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
            configuration.timeoutIntervalForRequest = request.timeoutInterval
            
            let manager = Manager(configuration: configuration)
            manager.startRequestsImmediately = false
            return manager
        }
    }
}

/// 取得Domain成功回調block
typealias GetDomainDataBlock = (DomainData?, NetworkError?, String?) -> Void

/// 檢查特定Domain是否可用的回調block
typealias PingDomainBlock = (NetworkError?) -> Void

extension APIProvider {
    
    /// 取得Domain列表
    ///
    /// - Parameter completion: api回調(DomainData)
    static func requestDomainList(index: Int, completion: @escaping GetDomainDataBlock) {
        
        let request = DomainAPI.GetDomainList(pathListIndex: index)
        let provider = self.createProvider(request)
        
        DispatchQueue.global().async {
            _ = provider.request(request, callbackQueue: DispatchQueue.global(), completion: { (result) in
                
                let url = "\(request.baseURL.absoluteString)/\(request.path)"
                
                switch result {
                case .success(let response):
                    
                    // 1.將json文本內文使用base64 decode解碼，解碼過後會得到json字串
                    guard let decodeData = Data(base64Encoded: response.data, options: .ignoreUnknownCharacters), let decodeJsonString = String(data: decodeData, encoding: .utf8) else {
                        completion(nil, .DecodingError(message: "Response Base64 解碼失敗"), url)
                        return
                    }
                    
                    // 2.將取得的json字串轉為data
                    guard let jsonData = decodeJsonString.data(using: .utf8) else {
                        completion(nil, .DecodingError(message: "JsonString轉Data失敗"), url)
                        return
                    }
                    
                    // 3.將JsonData轉成JsonObject
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        // 4.將JsonObject轉成NSDictionary
                        guard let jsonDic = jsonObject as? NSDictionary else {
                            completion(nil, .DecodingError(message: "JsonObject非NSDictionary"), url)
                            return
                        }
                        
                        // 5.從JsonDic中擷取key為iv的值
                        guard let ivString = jsonDic.object(forKey: "iv") as? String else {
                            completion(nil, .DecodingError(message: "jsonDic中沒有Key為iv的值或Key為iv的值非String"), url)
                            return
                        }
                        // 6.將iv值使用base64轉成data
                        guard let ivData = NSData(base64Encoded: ivString, options: .ignoreUnknownCharacters) else {
                            completion(nil, .DecodingError(message: "ivString轉Data失敗"), url)
                            return
                        }
                        
                        // 7.將定義好的DoaminKey轉成Data
                        guard let keyData = kDomainJsonKey.data(using: .utf8) as NSData? else {
                            completion(nil, .DecodingError(message: "DomainJsonKey轉Data失敗"), url)
                            return
                        }
                        
                        // 8.從JsonDic中擷取key為value的值
                        guard let valueString = jsonDic.object(forKey: "value") as? String else {
                            completion(nil, .DecodingError(message: "jsonDic中沒有Key為value的值或Key為value的值非String"), url)
                            return
                        }
                        
                        // 9.用ivData與keyData解密value
                        let decryptJsonString = valueString.decryptAES128By(keyData: keyData, ivData: ivData)
                        
                        // 10.將解密後的字串轉成Data
                        if let jsonData = decryptJsonString.data(using: .utf8) {
                            do {
                                let model: DomainData? = try JSONDecoderHelper.model(from: jsonData)
                                completion(model, nil, url)
                            } catch {
                                completion(nil,error as? NetworkError, url)
                            }
                        } else {
                            completion(nil, .DecodingError(message: "解密字串轉成Dat失敗"), url)
                        }
                    } catch {
                        completion(nil, .DecodingError(message: "JsonData解析失敗：\(error.localizedDescription)"), url)
                    }
                    break
                case .failure(let error):
                    let e = NetworkError.ServerErrorResponse(message: error.localizedDescription, code: error.errorCode)
                    completion(nil, e, url)
                    break
                }
            })
        }
    }
    
    /// 檢查Domain是否可用
    ///
    /// - Parameters:
    ///   - domain: domain
    ///   - completion: api回調(有錯誤回傳NetwrokError)
    static func requestPingDomain(domain: String, completion: @escaping PingDomainBlock) {
        
        let request = DomainAPI.PingDomain(domain: domain)
        let provider = self.createProvider(request)
        
        DispatchQueue.global().async {
            _ = provider.request(request, callbackQueue: DispatchQueue.global(), completion: { (result) in
                switch result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    switch error.errorCode {
                    case 200, 403, 404, -2102:
                        completion(nil)
                    default:
                        let e = NetworkError.ServerErrorResponse(message: error.localizedDescription, code: error.errorCode)
                        completion(e)
                    }
                }
            })
        }
    }
    
    /// 將PingDomain錯誤回傳至後台
    ///
    /// - Parameter msg: 錯誤訊息
    static func requestLogPingDomainError(msg: String) {
        
        let request = DomainAPI.LogDomainError(msg: msg)
        let provider = self.createProvider(request)
        
        DispatchQueue.global().async {
            _ = provider.request(request, callbackQueue: DispatchQueue.global(), completion: { (result) in
                
            })
        }
    }
}

/// 取得IG Data成功回調block
typealias GetIGDataBlock = (IGData?, NetworkError?) -> Void

extension APIProvider {
    
    static func requestIGToken(userId: String, accessToken: String, completion: @escaping GetIGDataBlock) {
        let request = IGAPIManager.GetIGToken(userId: userId, accessToken: accessToken)
        self.specialRequestl(request: request, keys: ["data"], completion: completion)
    }
}
