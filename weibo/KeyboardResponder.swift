//
//  KeyboardResponder.swift
//  weibo
//
//  Created by 小天才智能电脑 on 2020/8/28.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//

import SwiftUI

class KeyboardResponder: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0 //键盘的高度
    var keyboardShow: Bool { keyboardHeight > 0}
    init() {
        //在默认的通知中心添加通知的监听者监听键盘即将出现的通知，当键盘即将出现的时候系统会发送一个通知，通知的监听者就会收到这个通知，监听者是self就是当前keyboardResponsder类产生的变量，当收到通知后就会执行#selector，object为谁发送的通知，nil只要键盘的通知就接受
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        //监听键盘的退出事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    //移除监听者
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //键盘即将出现
    @objc private func keyboardWillShow(_ notification: Notification){
        //keyboardFrameEndUserInfoKey键盘结束时就是屏幕的位置的大小 as? CGRect可以转换为CGRect 不能的话为nil
        guard let frame = notification.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect else{
            return
        }
        keyboardHeight = frame.height
    }
    //键盘即将退出
    @objc private func keyboardWillHide(_ notification: Notification){
        keyboardHeight = 0
    }
}


