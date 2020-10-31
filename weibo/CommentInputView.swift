//
//  CommentInputView.swift
//  weibo
//
//  Created by 小天才智能电脑 on 2020/8/28.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//

import SwiftUI

struct CommentInputView: View {
    let post : Post
    @State private var text: String = ""
    //添加属性是否显示评论是否为空
    @State private var showEmptyTextHUD: Bool = false
    
    //presentationMode存贮在字段属性的值
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userData: UserData
    //ObservedObject与EnvironmentObject相同点 属性改变view就会跟新，ObservedObject不同点属性需要赋值
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    var body: some View {
        VStack(spacing: 0){
            CommentTextView(text: $text, beginEdittingOnAppear: true)//首次出现则进入编辑状态
            
            HStack(spacing: 0){
                Button(action: {
                    //当前模态退出
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("取消")
                        .padding()
                }
                Spacer()
                
                Button(action: {
                    //空格回车过滤掉为空的字符串
                    if self.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                        self.showEmptyTextHUD = true
                        //显示1.5秒后评论是否为空隐藏
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                            self.showEmptyTextHUD = false
                        }
                        return
                    }
                    print(self.text)
                    var post = self.post
                    post.commentCount += 1
                    self.userData.update(post)
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("发送")
                        .padding()
                }
                
            }.font(.system(size: 18))
            .foregroundColor(.black)
            
        }
        .overlay(
            Text("评论不能为空")
                //缩放效果 出现时从0.5变1倍
                .scaleEffect(showEmptyTextHUD ? 1 : 0.5)
                .animation(.spring(dampingFraction: 0.5)) //回弹效果0.5-1.2-1.1-1倍
                //显示透明度
                .opacity(showEmptyTextHUD ? 1 : 0)
                .animation(.easeInOut))
        .padding(.bottom, keyboardResponder.keyboardHeight)
            //键盘忽略安全限制 //键盘出现忽略底部安全，键盘退出保留安全区域
        .edgesIgnoringSafeArea(keyboardResponder.keyboardShow ? .bottom : [])
        
    }
}

struct CommentInputView_Previews: PreviewProvider {
    static var previews: some View {
        CommentInputView(post: UserData().recommendPostList.list[0])
    }
}
