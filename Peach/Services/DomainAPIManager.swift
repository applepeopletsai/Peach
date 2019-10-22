//
//  DomainAPIManager.swift
//  BlockchainWallet_Swift
//
//  Created by Daniel on 2019/7/26.
//  Copyright © 2019 Daniel. All rights reserved.
//

import Moya
//import Alamofire

enum DomainAPI {
    
    struct GetDomainList: ApiTargetType {
        typealias ResponseDataType = DomainData
        
        var baseURL: URL { return URL(string: "https://raw.githubusercontent.com/tomoe2code/static_files/master")! }
        
        var path: String {
            var array: [String] = []
            #if ALPHA
            array = ["21967093"]
            #else
            array = ["39746589"]
            #endif
            
            if pathListIndex < array.count {
                return array[pathListIndex]
            } else {
                return ""
            }
        }
        
        var headers: [String : String]? { return nil }
        
        var pathListIndex: Int
        
        init(pathListIndex: Int = 0) {
            self.pathListIndex = pathListIndex
        }
    }
    
    struct PingDomain: ApiTargetType {
        typealias ResponseDataType = Data
        
        var baseURL: URL { return URL(string: domain)! }
        
        var domain: String
        
        init(domain: String) {
            self.domain = domain
        }
    }
    
    struct LogDomainError: ApiTargetType {
        typealias ResponseDataType = Data
        
        var baseURL: URL { return URL(string: "http://dandan.awesomegaming.io:8081/api/log")! }
        
        var method: HTTPMethod { return .post }
        
        var task: Task {
            return .requestParameters(parameters: ["platform":"1","message":msg], encoding: JSONEncoding.default)
        }
        
        var msg: String
        
        init(msg: String) {
            self.msg = msg
        }
    }
}

class DomainAPIManager {
    private(set) static var shared = DomainAPIManager()
    
    private(set) var domainData: DomainData?
    private(set) var currentApiDomain: String = ""
    private(set) var currentImageDomain: String = ""
    
    private init() {}
    
    func updataAvailableDomainData(successHandler: @escaping ActionHandler, failHandler: @escaping ActionHandler) {
        
        DispatchQueue.global().async {
            
            self.pingAvailableUrl(index: 0, completion: { (index) in
                
                if index == NSNotFound {
                    failHandler()
                } else {
                    
                    //確認DomainDat中的Domain是否可用
                    self.pingCurrentDomainDataIsAvailable(completion: { (availableApiDomainIndex, availablePictureDomainIndex) in
                        
                        if let domainData = self.domainData {
                            
                            if availableApiDomainIndex != NSNotFound {
                                self.currentApiDomain = domainData.apiDomain[availableApiDomainIndex].domain
                            }
                            
                            if availablePictureDomainIndex != NSNotFound {
                                self.currentImageDomain = domainData.pictureDomain[availablePictureDomainIndex].domain
                            }
                        }
                        
                        if availableApiDomainIndex != NSNotFound {
                            successHandler()
                        } else {
                            failHandler()
                        }
                    })
                }
            })
        }
    }
    
    private func pingAvailableUrl(index: Int, completion: @escaping (_ availableUrlIndex: Int) -> Void) {
        
        API.requestDomainList(index: index, completion: { (model, error, url) in
            
            let url = url ?? ""
            
            if let error = error {
                print("PingNotAvailableUrl: \(url)")
                
                var log = "Get Domain Error"
                
                switch error {
                case .DecodingError(_):
                    log += "，url: \(url), json檔案格式有問題"
                    break
                default:
                    if let code = error.code, code == 400 {
                        completion(NSNotFound)
                        return
                    } else {
                        //紀錄失敗
                        log += "，url: \(url), HttpStatusCode: \(error.code ?? 0)"
                    }
                    break
                }
                
                API.requestLogPingDomainError(msg: log)
                
                //檢查下一個
                self.pingAvailableUrl(index: index + 1, completion: completion)
            } else {
                print("PingAvailableUrl: \(url)")
                self.domainData = model
                completion(index)
            }
        })
        
    }
    
    private func pingCurrentDomainDataIsAvailable(completion: @escaping (_ apiDomainIndex: Int, _ pictureDomainIndex: Int) -> Void) {
        var availableApiDomainIndex = NSNotFound
        var availablePictureDomainIndex = NSNotFound
        
        DispatchQueue.global().async {
            
            let group = DispatchGroup()
            
            // Ping Domain (API)
            group.enter()
            self.pingAvailableDomain(domainList: self.domainData!.apiDomain, index: 0, completion: { (index) in
                availableApiDomainIndex = index
                group.leave()
            })
            
            // Ping Domain (Image)
            group.enter()
            self.pingAvailableDomain(domainList: self.domainData!.pictureDomain, index: 0, completion: { ( index) in
                availablePictureDomainIndex = index
                group.leave()
            })
            
            group.notify(queue: .global(), execute: {
                completion(availableApiDomainIndex, availablePictureDomainIndex)
            })
        }
    }
    
    private func pingAvailableDomain(domainList: [DomainData.Data], index: Int, completion: @escaping (_ availableDomainIndex: Int) -> Void) {
        
        if index < domainList.count {
            let domain = domainList[index].domain
            
            API.requestPingDomain(domain: domain, completion: { (error) in
                if error != nil {
                    print("PingNotAvailableDomain: \(domain)")
                    
                    //ping失敗，換下一個Domain
                    if index + 1 < domainList.count {
                        self.pingAvailableDomain(domainList: domainList, index: index + 1, completion: completion)
                    } else {
                        completion(NSNotFound)
                    }
                } else {
                    print("PingAvailableDomain: \(domain)")
                    completion(index)
                }
            })
        } else {
            completion(NSNotFound)
        }
    }
    
}
