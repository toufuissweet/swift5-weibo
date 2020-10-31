//
//  UserData.swift
//  weibo
//
//  Created by 小天才智能电脑 on 2020/8/27.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//
import Foundation
import Combine

//定义环境对象的类型
class UserData: ObservableObject { //@Published 属性发生变换 用到的view就会跟新
    @Published  var recommendPostList: PostList = loadPostListData("PostListData_recommend_1.json") //推荐列表
    @Published var hotPostList: PostList = loadPostListData("PostListData_hot_1.json") //热门列表
    @Published var isRefreshing: Bool = false //正在刷新
    @Published var isLoadingMore: Bool = false //下拉加载更多
    @Published var loadingError: Error? //如果加载失败显示错误提示框
    
    //字典通过id查找相应的微博 private 内部使用
    private var recommendPostDic: [Int: Int] = [:] //key的类型是int value的类型也是int key表示微博的id value表示在数组里边的序号 方便跟新微博
    private var hotPostDic: [Int: Int] = [:]
    
    init() {
        //遍历数组跟新相应的字典
        for i in 0..<recommendPostList.list.count {
            let post = recommendPostList.list[i]
            recommendPostDic[post.id] = i
        }
        for i in 0..<hotPostList.list.count{
            let post = hotPostList.list[i]
            hotPostDic[post.id] = i
        }
    }
}

//枚举
enum PostListCategory {
    case recommend, hot
}
//扩展
extension UserData{
    var showLoadingError: Bool { loadingError != nil}
    var loadingErrorText: String { loadingError?.localizedDescription ?? "" }//错误信息文本 ？？当前面的值为空的时候就用后边的默认值
    
    //通过微博列表的类型，找到相应的微博列表
    func postList(for category: PostListCategory) -> PostList {
        switch category {
        case .recommend:
            return recommendPostList
        case .hot:
            return hotPostList
        }
    }
    
    //下拉刷新时需要网络请求数据跟新userdata里的列表，数据跟新后，postlistView页面就会跟新
    func refreshPostList(for category: PostListCategory) {
        switch category {
        case .recommend:
            NetworkAPI.recommendPostList { result in
                switch result {
                case let .success(list): self.handleRefreshPostList(list, for: category)
                case let .failure(error): self.handleLoadingError(error)
                }
                self.isRefreshing = false
            }
        case .hot:
            NetworkAPI.hotPostList { result in
            switch result {
            case let .success(list): self.handleRefreshPostList(list, for: category)
            case let .failure(error): self.handleLoadingError(error)
            }
            self.isRefreshing = false
            }
        }
    }
    
    //上拉加载更多
    func loadMorePostList(for category: PostListCategory) {
        //如果正在加载更多，如果列表数据大于10个则返回
        if isLoadingMore || postList(for: category).list.count > 10 { return }
        isLoadingMore = true
        
        switch category {
        case .recommend:
            //如果是推荐列表加载更多的时候获取热门列表的数据
            NetworkAPI.hotPostList { result in
                switch result {
                case let .success(list): self.handleLoadMorePostList(list, for: category)
                case let .failure(error): self.handleLoadingError(error)
                }
                self.isLoadingMore = false
            }
        case .hot:
            NetworkAPI.recommendPostList { result in
                switch result {
                case let .success(list): self.handleLoadMorePostList(list, for: category)
                case let .failure(error): self.handleLoadingError(error)
                }
                self.isLoadingMore = false
            }
        }
    }
    
    //处理加载更多的成功数据
    private func handleLoadMorePostList(_ list: PostList, for category: PostListCategory){
        switch category {
        case .recommend:
            //遍历整个数组，取出其中的元素post，检查是否重复
            for post in list.list {
                //如果推荐列表的字典查找post.id 不为空说明重复 跳入下次循环
                if recommendPostDic[post.id] != nil { continue }
                //没有找到东西，说明新的数据 加入新的列表
                //需要加入推荐列表
                recommendPostList.list.append(post)
                //跟新字典，元素序号就是元素数组-1
                recommendPostDic[post.id] = recommendPostList.list.count - 1
            }
        case .hot:
            for post in list.list {
                if hotPostDic[post.id] != nil { continue }
                hotPostList.list.append(post)
                hotPostDic[post.id] = hotPostList.list.count - 1
            }
        }
    }
    
    
    //处理下拉刷新得到的数据
    private func handleRefreshPostList(_ list: PostList, for category: PostListCategory){
        //创建数组
        var tempList: [Post] = []
        //创建字典
        var tempDic: [Int: Int] = [:]
        //list.list元素为Post的数组，遍历数组，每次取出数组的元素以及数组中的序号
        for (index, post)in list.list.enumerated() {
            //如果字典查找post.id 不为空(重复了)则进入下一次循环
            if tempDic[post.id] != nil { continue}
            //加入字典和数组
            tempList.append(post)
            tempDic[post.id] = index
        }
        //跟新userdata的属性
        switch category {
        case .recommend:
            recommendPostList.list = tempList
            recommendPostDic = tempDic
        case .hot:
            hotPostList.list = tempList
            hotPostDic = tempDic
        }
    }
    
    //处理错误函数
    private func handleLoadingError(_ error: Error){
        //如果有错误给error赋值
        loadingError = error
        //错误信息提示框
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.loadingError = nil
        }
    }
    
    //通过微博的id，找到一条相应的微博 外部参数名forId 内部参数名id
    func post(forId id: Int) -> Post? {
        if let index = recommendPostDic[id] {
            return recommendPostList.list[index]
        }
        if let index = hotPostDic[id] {
            return hotPostList.list[index]
        }
        return nil
    }
    //跟新一条微博 外部参数为空为_ 内部参数为post
    func update(_ post: Post){
        if let index = recommendPostDic[post.id]{
            recommendPostList.list[index] = post //让数组的第index个 赋值
        }
        if let index = hotPostDic[post.id]{
            hotPostList.list[index] = post
        }
    }
}
