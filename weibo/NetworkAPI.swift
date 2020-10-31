//应用程序接口
//  NetworkAPI.swift
//  Network
//
//  Created by 小天才智能电脑 on 2020/8/30.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//

import Foundation


class NetworkAPI {
    //获取推荐列表封装成静态函数
    static func recommendPostList(completion: @escaping (Result<PostList, Error>) -> Void){
        NetworkManager.shared.requestGet(path: "PostListData_recommend_1.json", parameters: nil) { result in
            switch result {
            case let .success(data):
                //T的类型为result的类型
                let parseResult: Result<PostList, Error> = self.parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    //获取推荐列表封装成静态函数
    static func hotPostList(completion: @escaping (Result<PostList, Error>) -> Void){
        NetworkManager.shared.requestGet(path: "PostListData_hot_1.json", parameters: nil) { result in
            switch result {
            case let .success(data):
                //T的类型为result的类型 定义了局部变量result 之后再写result都为局部变量
                let parseResult: Result<PostList, Error> = self.parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    //创建微博（帖子）的接口，Result Post为数据结构
    static func createPost(text: String, completion: @escaping (Result<Post, Error>) -> Void) {
        //在数据库里添加数据
        NetworkManager.shared.requestPost(path: "createpost", parmeters: ["text": text]) { result in
            switch result {
            case let .success(data):
                //创建临时变量
                let parseResult: Result<Post, Error> = self.parseData(data)
                completion(parseResult)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    

    //解析数据 泛型 T遵循Decodable协议，T的类型不知道，T的类型需要函数调用的时候确定
    private static func parseData<T: Decodable>(_ data: Data) -> Result<T, Error> {
        guard let decodeData = try? JSONDecoder().decode(T.self, from: data) else{
            //如果数据解析失败
            //NSError domain错误来源 code错误码 userInfo自定义的错误用户友好的提示语
            let error = NSError(domain: "NetworkAPIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Can not parse data"])
            return .failure(error)
        }
        return .success(decodeData)
    }

}
