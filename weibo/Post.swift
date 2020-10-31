//
//  Post.swift
//  weibo
//
//  Created by 小天才智能电脑 on 2020/8/26.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//
import SwiftUI


struct PostList: Codable {
    var list: [Post]
    
}

struct Post: Codable,Identifiable{ //codable协议 可从json转换过来，也可转换为json
    //属性
    let id: Int
    let avatar: String //头像图片名称
    let vip: Bool //是否vip
    let name: String //用户昵称
    let date: String //发布日期
    
    var isFollowed: Bool //是否关注
    
    let text: String
    let images: [String]
    
    var commentCount: Int //评论数
    var likeCount: Int //点赞数
    var isLiked: Bool //是否点赞
    
    
    //let不可变， 可变用var
}
extension Post: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension Post{
    var avatarImage: Image{
        return loadImage(name: avatar)
    }
    
    var commentCountText: String{
        if commentCount <= 0{
            return "评论"
        }
        if commentCount < 1000{
            return "\(commentCount)"
        }
        return String(format: "%.1fK", Double(commentCount)/1000)
    }
    
    var likeCountText: String{
        if likeCount <= 0{
            return "点赞"
        }
        if likeCount < 1000{
            return "\(likeCount)"
        }
        return String(format: "%.1fK", Double(likeCount)/1000)
    }
}
//let postList = loadPostListData("PostListData_recommend_1.json")


//解析微博数据函数
func loadPostListData(_ fileName: String) -> PostList {
    //通过文件名获取url
    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        fatalError("Can not find \(fileName) in main bundle")
    }
    //通过url加载数据
    guard let data = try? Data(contentsOf: url) else {
        fatalError("Can not load \(url)")
    }
    //通过数据（json）转换成要的数据模型
    guard let list = try? JSONDecoder().decode(PostList.self, from: data) else {
        fatalError("Can not parse post list json data")
    }
    return list
}

func loadImage(name:String) ->Image{
    return Image(uiImage: UIImage(named: name)!)
}
