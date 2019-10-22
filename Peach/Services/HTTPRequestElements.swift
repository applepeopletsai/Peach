//
//  HTTPRequestElements.swift
//  Peach
//
//  Created by dean on 2019/8/7.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

public typealias HTTPHeaders = [String:String]

public typealias HTTPParamaters = [String:Any]

public enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}

public enum HTTPTask {
    case request
    
//    case requestParameters(bodyParameters: Parameters?,
//        bodyEncoding: ParameterEncoding,
//        urlParameters: Parameters?)
//
//    case requestParametersAndHeaders(bodyParameters: Parameters?,
//        bodyEncoding: ParameterEncoding,
//        urlParameters: Parameters?,
//        additionHeaders: HTTPHeaders?)
    
    // case download, upload...etc
}
enum NetworkResponse<T> {
    case success(T)
    case failure(NetworkError)
}
enum NetworkError: Error {
    case HttpStatusCodeError(message: String, code: Int)
    case ResponseTimeOut
    case ServerErrorResponse(message: String, code: Int)
    case DecodingError(message: String)
    case JsonDecodingError(context: DecodingError.Context, model: Codable.Type)
    case JsonSerializationError(type: SerializationError)
    
    enum SerializationError {
        case SerializationJsonObjectFail(key: String)
        case SerializationDataFail(key: String)
        case KeyNotFound(key: String)
    }
}

extension NetworkError {
    var message: String {
        switch self {
        case let .HttpStatusCodeError(msg, code):
            return "Request fail: ErrorMessage: \(msg), HttpStatusCode: \(code)"
        case .ResponseTimeOut:
            return "Time Out"
        case let .ServerErrorResponse(msg, _):
            return msg
        case let .DecodingError(msg):
            return msg
        case let .JsonDecodingError(content, model):
            return "\(model.self) property match fail, path: \(content.codingPath), \(content.debugDescription)"
        case let .JsonSerializationError(type):
            switch type {
            case let .SerializationJsonObjectFail(key):
                return "Data Serialization to JsonObject failed in \(key)"
            case let .SerializationDataFail(key):
                return "JsonObject Serialization to data failed in \(key)"
            case let  .KeyNotFound(key):
                return "The key:\(key) is not found"
            }
        }
    }
    
    var code: Int? {
        switch self {
        case let .ServerErrorResponse(_,code), let .HttpStatusCodeError(_, code):
            return code
        case .ResponseTimeOut:
            return NSURLErrorTimedOut
        default:
            return nil
        }
    }
}

//func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
//
//}
