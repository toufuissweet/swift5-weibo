//
//  HomeNavigationBar.swift
//  weibo
//
//  Created by 小天才智能电脑 on 2020/8/27.
//  Copyright © 2020 小天才智能电脑. All rights reserved.
//

import SwiftUI

private let kLabelWidth: CGFloat = 60
private let kButtonHeight: CGFloat = 24

struct HomeNavigationBar: View {
    @Binding var leftPercent : CGFloat //为0 下划线在左边， 为1 下划线在右边 @State var值变了跟新视图 @Binding 绑定 与HomeView绑定一起
    
    var body: some View {
        HStack(alignment: .top, spacing: 0){
            
            Button(action: {
                print("click camera button")
            }){
                Image(systemName: "camera")
                .resizable()
                .scaledToFit()
                    .frame(width: kLabelWidth, height: kButtonHeight)
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                    .foregroundColor(.black)
            }
            
            VStack(spacing: 3){
                HStack(spacing: 0) {
                    Text("推荐")
                    .bold()
                        .frame(width:kLabelWidth, height: kButtonHeight)
                        .padding(.top, 5)
                        .opacity(Double(1 - leftPercent * 0.5)) //透明度
                        //点击事件 view的颜色不会改变
                        .onTapGesture {
                            withAnimation{
                                self.leftPercent = 0
                            }
                        }
                    
                    Spacer()
                    
                    Text("热门")
                    .bold()
                        .frame(width:kLabelWidth, height: kButtonHeight)
                        .padding(.top, 5)
                        .opacity(Double(0.5 + leftPercent * 0.5)) //透明度
                        .onTapGesture {
                            withAnimation{
                                self.leftPercent = 1
                            }
                        }
                    
                }
                
                .font(.system(size: 20))
                GeometryReader{ geometry in //读取几何 尽可能扩张自己的view 动态适应的view宽度
                    RoundedRectangle(cornerRadius: 2)
                    .foregroundColor(.orange)
                    .frame(width: 50, height: 4)
                    .offset(x: geometry.size.width * self.leftPercent + kLabelWidth * (0.5 - self.leftPercent) - 30)
                }
                .frame(height: 6)
            }
            .frame(width:UIScreen.main.bounds.width * 0.5) //整个宽度的一半
            
            Spacer()
            Button(action: {
                print("click add button")
            }){
                Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                    .frame(width: kLabelWidth, height: kButtonHeight)
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                    .foregroundColor(.orange)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct HomeNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeNavigationBar(leftPercent: .constant(0))
    }
}
