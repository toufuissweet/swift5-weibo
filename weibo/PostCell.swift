//
//  PostCell.swift
//  weibo
//
//  Created by 小天才智能电脑 on 2020/8/25.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//

import SwiftUI

struct PostCell: View {
    let post: Post
    //从userData里通过微博的id找到这条微博
    var bindingPost: Post{
        userData.post(forId: post.id)!
    }
    @State var presentComment: Bool = false
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        var post = bindingPost
        return VStack(alignment: .leading, spacing: 10){
            HStack(spacing: 5)//右边间距
            {
                post.avatarImage
                    .resizable()  //可修改图片
                    .scaledToFill() //保持原图比缩放
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        PostVipBadge(vip: post.vip)
                            .offset(x: 16, y: 16) //位置放置
                )
                    
                VStack(alignment: .leading, spacing: 5 ) {
                    Text(post.name)
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 100/255, green: 242/255, blue: 242/255 ))
                        .lineLimit(1)
                    Text(post.date)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
                .padding(.leading,10)//左边间距
                
                if !post.isFollowed{
                    Spacer()
                    Button(action:{withAnimation{
                        post.isFollowed = true
                        self.userData.update(post) //跟新userData
                        }
                    }){
                        Text("关注")
                            .font(.system(size: 14))
                            .foregroundColor(.orange)
                            .frame(width: 50, height: 26)
                            .overlay( //叠加
                                RoundedRectangle(cornerRadius: 13)//圆角
                                    .stroke(Color.orange, lineWidth: 1)//描边
                        )
                    }
                .buttonStyle(BorderlessButtonStyle())
                }else if post.isFollowed{
                    Spacer()
                    Button(action:{withAnimation{
                        post.isFollowed = false
                        self.userData.update(post) //跟新userData
                        }
                        }){
                            Text("取消关注")
                                .font(.system(size: 14))
                                .foregroundColor(.orange)
                                .frame(width: 100, height: 26)
                                .overlay( //叠加
                                    RoundedRectangle(cornerRadius: 13)//圆角
                                        .stroke(Color.orange, lineWidth: 1)//描边
                            )
                        }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            Text(post.text)
                .font(.system(size: 17))
            if !post.images.isEmpty{
                PostImageCell(images: post.images, width: UIScreen.main.bounds.width - 30)
            }
            Divider() //分隔线
            
            HStack(spacing: 0){
                Spacer()
                
                PostCellToolBarButton(image: "message",
                                      text: post.commentCountText,
                                      color: .black)
                {
                    self.presentComment = true
                }
                    //评论按钮
                .sheet(isPresented: $presentComment){
                    //推出CommentInputView 生成CommentInputView添加环境对象
                    CommentInputView(post: post).environmentObject(self.userData)
                }
                Spacer()
            
                PostCellToolBarButton(image: post.isLiked ? "heart.fill" : "heart",
                                      text: post.likeCountText,
                                      color: post.isLiked ? .red : .black)
                {
                    if post.isLiked {
                        post.isLiked = false
                        post.likeCount -= 1
                    }else{
                        post.isLiked = true
                        post.likeCount += 1
                    }
                    self.userData.update(post) //跟新userdata
                }
                Spacer()
            }
            Rectangle()
                .padding(.horizontal, -15)
                .frame(height: 10)
                .foregroundColor(Color(red: 238/255, green: 238/255, blue: 238/255))
        }
        .padding(.horizontal, 15)
        .padding(.top, 15)
        
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return PostCell(post: userData.recommendPostList.list[10]).environmentObject(userData)
    }
}
