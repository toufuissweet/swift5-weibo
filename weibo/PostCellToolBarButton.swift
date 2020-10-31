//
//  PostCellToolBarButton.swift
//  weibo
//
//  Created by 小天才智能电脑 on 2020/8/26.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//

import SwiftUI



struct PostCellToolBarButton: View {
    
    let image: String //名称
       let text: String
       let color: Color
       let action: () -> Void
    
    var body: some View {
        Button(action: action){
            HStack(spacing: 5){
                Image(systemName: image)
                .resizable()
                .scaledToFit() //适应保证不会超出框框的位置
                    .frame(width: 18, height: 18)
                Text(text)
                    .font(.system(size: 15))
            }
        }
    .foregroundColor(color)
    .buttonStyle(BorderlessButtonStyle())
    }
}

struct PostCellToolBarButton_Previews: PreviewProvider {
    static var previews: some View {
        PostCellToolBarButton(image: "heart", text: "点赞", color: .red){
            print("点赞")
        }
    }
}
