//
//  NetworkManager.swift
//  WeiboUI
//
//  Created by app on 2022/12/17.
//

import SwiftUI
import Alamofire
typealias NetworkRequestResult = Result<Data,Error>
typealias NetworkRequestCompletion = (NetworkRequestResult) -> Void
private let NetworkAPIBaseURL = "https://github.com/xiaoyouxinqing/PostDemo/raw/master/PostDemo/Resources/"

class NetworkManager {
    static let shard = NetworkManager()
    var commonHeaders:HTTPHeaders {["user_id":"123","token":"XXXX"]}
    private init() {}
    
    @discardableResult
    func requestGet(path: String,parameters:Parameters?,completion:@escaping NetworkRequestCompletion) -> DataRequest {
        AF.request(NetworkAPIBaseURL + path,parameters: parameters,headers: commonHeaders,requestModifier: {$0.timeoutInterval = 15})
            .responseData { response in
                switch response.result{
                case let .success(data):completion(.success(data))
                case let .failure(error):completion(self.handleError(error))
                }
            }
    }
    
    @discardableResult
    func requestPost(path: String,parameters:Parameters?,completion:@escaping NetworkRequestCompletion) -> DataRequest {
        AF.request(NetworkAPIBaseURL + path,method: .post, parameters: parameters,encoding: JSONEncoding.prettyPrinted, headers: commonHeaders,requestModifier: {$0.timeoutInterval = 15})
            .responseData { response in
                switch response.result{
                case let .success(data):completion(.success(data))
                case let .failure(error):completion(self.handleError(error))
                }
            }
    }
    
    private func handleError(_ error: AFError) -> NetworkRequestResult {
          if let underlyingError = error.underlyingError {
              let nserror = underlyingError as NSError
              let code = nserror.code
              if  code == NSURLErrorNotConnectedToInternet ||
                  code == NSURLErrorTimedOut ||
                  code == NSURLErrorInternationalRoamingOff ||
                  code == NSURLErrorDataNotAllowed ||
                  code == NSURLErrorCannotFindHost ||
                  code == NSURLErrorCannotConnectToHost ||
                  code == NSURLErrorNetworkConnectionLost {
                  var userInfo = nserror.userInfo
                  userInfo[NSLocalizedDescriptionKey] = "网络连接有问题喔～"
                  let currentError = NSError(domain: nserror.domain, code: code, userInfo: userInfo)
                  return .failure(currentError)
              }
          }
          return .failure(error)
      }
    
    // 211.5
    //202.5 
}
