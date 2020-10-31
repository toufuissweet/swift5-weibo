//
//  NetworkManager.swift
//  Network
//
//  Created by 小天才智能电脑 on 2020/8/30.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//

import Foundation
import Alamofire

//闭包类型 请求回调
typealias NetworkRequestResult = Result<Data, Error>
typealias NetworkRequestCompletion = (NetworkRequestResult) -> Void
//url路径的前部分
private let NetworkAPIBaseURL = "https://github.com/xiaoyouxinqing/PostDemo/raw/master/PostDemo/Resources/"

class NetworkManager {
    //共享变量，单例
    static let shared = NetworkManager()
    
    var commonHeaders: HTTPHeaders { ["user_id": "123", "token": "XXXXXX"] }
    
    //外部调用这个函数返回值可以忽略
    @discardableResult
    //http get请求
    //path路径参数（拼接域名后的路径） parmeter参数名 get请求拼接路径后的参数 completion请求完成后的闭包 DataRequest返回值
    func requestGet(path: String, parameters: Parameters?, completion: @escaping NetworkRequestCompletion) -> DataRequest {
        //发送请求 headers加入字段内容 requestModifier超时时间为15秒
        AF.request(NetworkAPIBaseURL + path,
                   parameters: parameters,
//                   headers: commonHeaders,
                   requestModifier: {$0.timeoutInterval = 15})
            //获取相应数据 判断是否成功
            .responseData { response in
                switch response.result {
                case let .success(data): completion(.success(data))
                case let .failure(error): completion(self.handleError(error))
                }
        }
    }
    
    @discardableResult
    func requestPost(path: String, parmeters: Parameters?, completion: @escaping NetworkRequestCompletion) -> DataRequest {
        //method 不写默认为get的方法 encoding参数转换成json
        AF.request(NetworkAPIBaseURL + path,
                   method: .post,
                   parameters: parmeters,
                   encoding: JSONEncoding.prettyPrinted,
//                   headers: commonHeaders,
                   requestModifier: {$0.timeoutInterval = 15})
            //获取相应数据 判断是否成功
            .responseData { response in
                switch response.result {
                case let .success(data): completion(.success(data))
                case let .failure(error): completion(self.handleError(error))
                }
        }
    }
    //处理AF.error 处理参数AFError 返回值请求结果
    private func handleError(_ error: AFError) -> NetworkRequestResult {
        //通过underlyingError拿到ios抛出的错误
        if let underlyingError = error.underlyingError {
            //转换成NSError
            let nserror = underlyingError as NSError
            let code = nserror.code
            if  code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorTimedOut ||
                code == NSURLErrorInternationalRoamingOff ||
                code == NSURLErrorDataNotAllowed ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost {
                //取出错误的userInfo 更改提示语
                var userInfo = nserror.userInfo
                userInfo[NSLocalizedDescriptionKey] = "网络连接有问题喔～"
                //生成新的错误
                let currentError = NSError(domain: nserror.domain, code: code, userInfo: userInfo)
                return .failure(currentError)
            }
        }
        return .failure(error)
    }
}
