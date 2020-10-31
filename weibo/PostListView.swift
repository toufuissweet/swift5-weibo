//
//  PostListView.swift
//  weibo
//
//  Created by 小天才智能电脑 on 2020/8/26.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//

import SwiftUI
import BBSwiftUIKit

struct PostListView: View {
    
    let category : PostListCategory
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        //用一个数组初始化一个list 数组里边的元素会遍历，每一次取出一个元素（一条微博）执行闭包里的指令，PostCell列表
        BBTableView(userData.postList(for: category).list){ post in
            //用上环境变量 通过微博列表的类型找到相应的列表
            
            NavigationLink(destination: PostDetailView(post: post)){
                PostCell(post: post)
            }
            .buttonStyle(OrignalButtonStyle())
        }
            //下拉刷新时候的标题
            .bb_setupRefreshControl({ control in
                control.attributedTitle = NSAttributedString(string: "加载中...")
            })
            .bb_pullDownToRefresh(isRefreshing: $userData.isRefreshing) {
                self.userData.refreshPostList(for: self.category)
                
//                print("Refresh")
//                self.userData.loadingError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error"])
//                //一秒钟之后 is refreshing改为false
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    self.userData.isRefreshing = false
//                    self.userData.loadingError = nil
//                }
                
        }
            //上拉加载更多
            .bb_pullUpToLoadMore(bottomSpace: 30) {
//                //如果已经加载更多
//                if self.userData.isLoadingMore { return }
//                //如果没有加载更多
//                self.userData.isLoadingMore = true
//                print("load more")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    self.userData.isLoadingMore = false
//                }
                self.userData.loadMorePostList(for: self.category)
        }
        .overlay(
            Text(userData.loadingErrorText)
                .bold()
                .frame(width: 200)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .opacity(0.8)
            )
                .animation(nil)
                .scaleEffect(userData.showLoadingError ? 1 : 0.5)
                .animation(.spring(dampingFraction: 0.5)) //回弹效果0.5-1.2-1.1-1倍
                //显示透明度
                .opacity(userData.showLoadingError ? 1 : 0)
                .animation(.easeInOut)
        )
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            PostListView(category: .recommend)
                .navigationBarTitle("title")
            //                .navigationBarHidden(true)
        }
        .environmentObject(UserData())
    }
}
