//
//  PostDetailView.swift
//  weibo
//
//  Created by 小天才智能电脑 on 2020/8/26.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//

import SwiftUI

struct PostDetailView: View {
    let post : Post
    
    var body: some View {
        List{
            PostCell(post: post)
            .listRowInsets(EdgeInsets())//间距为空
            
            ForEach(1...10, id: \.self){ i in
                Text("评论\(i)")
            }
        }
        .navigationBarTitle("详情",displayMode: .inline)
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return PostDetailView(post: userData.recommendPostList.list[0]).environmentObject(userData)
    }
}
