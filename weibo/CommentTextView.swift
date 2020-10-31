//
//  CommentTextView.swift
//  weibo
//
//  Created by 小天才智能电脑 on 2020/8/28.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//

import SwiftUI

struct CommentTextView: UIViewRepresentable {
    @Binding var text: String
    
    //是否第一次出现的时候就进入编辑状态
    let beginEdittingOnAppear: Bool
    
    //添加数据
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.backgroundColor = .systemGray6
        view.font = .systemFont(ofSize: 18)
        //设置字体与边框的间距
        view.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        view.delegate = context.coordinator
        //附上文本
        view.text = text
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if beginEdittingOnAppear,
            !context.coordinator.didBecomeFirstResponser, //还没有变成第一响应者
            uiView.window != nil, //UITextView显示出来才能进入编辑状态
            !uiView.isFirstResponder{ //不是第一响应者
            uiView.becomeFirstResponder()//成为第一响应者才能编辑状态
            context.coordinator.didBecomeFirstResponser = true //指令只会执行一次
        }
    }
    
    //定义Coordinator的类
    class Coordinator: NSObject, UITextViewDelegate{
        let parent : CommentTextView
        var didBecomeFirstResponser: Bool = false
        
        init(_ view: CommentTextView) {
            parent = view
        }
        //文本框里的文本发生变换调用 ，文本跟新数据
        func textViewDidChange(_ textView: UITextView) {
            //文本发生变换
            parent.text = textView.text
        }
    }
    
}

struct CommentTextView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTextView(text: .constant(""), beginEdittingOnAppear: true)
    }
}
