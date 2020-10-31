//
//  HomeView.swift
//  weibo
//
//  Created by 小天才智能电脑 on 2020/8/27.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State private var leftPercent: CGFloat = 0
    init() {
        //设置所有的uitableview没有分割线
        UITableView.appearance().separatorStyle = .none
        //点击tableview的风格
        UITableViewCell.appearance().selectionStyle = .none
    }
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                HScrollViewController(pageWidth: geometry.size.width,
                                      contentSize: CGSize(width: geometry.size.width * 2,
                                                          height: geometry.size.height),
                                      leftPercent: self.$leftPercent)
                {
                    HStack(spacing: 0){
                        PostListView(category: .recommend)
                            .frame(width: UIScreen.main.bounds.width)
                        PostListView(category: .hot)
                            .frame(width: UIScreen.main.bounds.width)
                    }
                }
                .edgesIgnoringSafeArea(.bottom)//忽略安全区域
            }
            .edgesIgnoringSafeArea(.bottom)//忽略安全区域
            .navigationBarItems(leading: HomeNavigationBar(leftPercent: $leftPercent))
            .navigationBarTitle("首页",displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())//ipad和iphone的样式一样
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserData())
    }
}
