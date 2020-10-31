//
//  HScrollViewController.swift
//  weibo
//
//  Created by 小天才智能电脑 on 2020/8/27.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//

import SwiftUI

//Content(泛型)必须遵循View的类型 UIViewControllerRepresentable
//UIViewControllerRepresentable UIKit里面的一个页面，可描述可表达
struct HScrollViewController<Content: View>: UIViewControllerRepresentable {
    let pageWidth: CGFloat //一页的宽度
    let contentSize: CGSize //里面展示内容的宽高
    let content: Content //展示的内容 Content是一种类型，必须遵循View
    @Binding var leftPercent: CGFloat
    
    init(pageWidth: CGFloat,
         contentSize: CGSize,
         leftPercent: Binding<CGFloat>,
         @ViewBuilder content: () -> Content) {
        self.pageWidth = pageWidth
        self.contentSize = contentSize
        self.content = content()
        self._leftPercent = leftPercent //初始化绑定要_
    }
    //当创建uiviewcontroler就能获取上下文，上下文的信息存到Coordinator，跟新UIViewControler时就能从上下文取出需要的信息，起到协调作用
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    //创建UIViewController
    func makeUIViewController(context: Context) -> UIViewController {
        let scrollView = UIScrollView()
        scrollView.bounces = false //禁止回弹
        scrollView.isPagingEnabled = true //开启分页效果
        scrollView.showsVerticalScrollIndicator = false //隐藏滚动条
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator
        context.coordinator.scrollView = scrollView //上下文
        
        let vc = UIViewController()
        vc.view.addSubview(scrollView)
        
        //SwiftUI的view添加到UIKit的UIViewControler面来 UIHostingController起到桥接的作用
        let host = UIHostingController(rootView: content)
        //创建父UIviewcontroller 子UIviewcontroller（host）
        vc.addChild(host)
        //scrollView添加hostviewControl的view的内容（swiftUI的view）
        scrollView.addSubview(host.view)
        //已经添加到父的vc
        host.didMove(toParent: vc)
        context.coordinator.host = host
        
        return vc
    }
    // 每次跟新view都会执行
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //取出scrollView
        let scrollView = context.coordinator.scrollView!
        scrollView.frame = CGRect(x: 0, y: 0, width: pageWidth, height: contentSize.height)
        scrollView.contentSize = contentSize
        scrollView.setContentOffset(CGPoint(x: leftPercent * (contentSize.width - pageWidth), y: 0), animated: true)
        context.coordinator.host.view.frame = CGRect(origin: .zero, size: contentSize)
        
    }
    //class 创建类coordinator 继承 NSObject object-c的内容 UIScrollViewDelegate协议
    class Coordinator: NSObject, UIScrollViewDelegate {
        let parent: HScrollViewController
        var scrollView: UIScrollView!
        var host: UIHostingController<Content>!
        
        init(_ parent: HScrollViewController) {
            self.parent = parent
        }
        //结束时执行的函数
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            withAnimation{
                parent.leftPercent = scrollView.contentOffset.x < parent.pageWidth * 0.5 ? 0 : 1 //停止执行：小于分页宽度一般的时候为0， 大于分页一半为1
            }
            
        }
    }
}
