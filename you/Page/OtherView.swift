//
//  OtherView.swift
//  you
//  注意badge属性在iOS15以上才生效
//  默认的TabView无法满足-自定义View处理
//  Created by 翁益亨 on 2024/6/28.
//

import SwiftUI

struct OtherView: View {
    @State private var selection = HomeTabBar.file.rawValue
    
    //在初始化时需要延时，在TabView内的视图如果过快显示会导致NavigationView的顶部标题栏出现
    @State private var delayInit = false
    
    var body: some View {
            //【TabBar自定义的控件最大的问题就是不能缓存当前的TabBar页面信息。只能通过系统的TabView结合tag标签来实现。底部自定义，TabView只是作为展示内容的容器】
            ZStack(alignment:Alignment(horizontal: .center, vertical: .bottom)){
               
                //由于TabView默认自带的底部边距，所以这里就
                TabView(selection: $selection) {
                    
                    if delayInit {
                        FileView().tag(HomeTabBar.file.rawValue)
                        MineView().tag(HomeTabBar.mine.rawValue)
                    }
                    
                }
                //切换tab可能会产生闪烁，关闭动画效果
                //不传入切换的指示器，设置可水平滑动
//                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                
                //底部切换的布局内容
                HStack(alignment:.bottom){
                    HomeTabBarView(item: .file, isSelected: selection == HomeTabBar.file.rawValue)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            selection = HomeTabBar.file.rawValue
                        }
                    HomeTabBarView(item: .mine, isSelected: selection == HomeTabBar.mine.rawValue)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            selection = HomeTabBar.mine.rawValue
                        }
                }.overlay(
                    //overlay在基础视图上叠加额外布局信息
                    
                    //底部占位按钮信息，通过偏移量达到效果
                    ZStack {
                        //底部TabBar的自定义高度为50.这里设置80后自动顶出位置
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 54.0, height: 54.0)

                        Image("icon_mic")
                            .resizable()
                            .frame(width: 50.0, height: 50.0)
                    }
                        .offset(x:0,y:-15),alignment: .top)
                
                
                
                
            }
            
        .onAppear{
            //视图 完全 展示在界面上时回调【页面跳转后返回会调用】
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                delayInit = true
            }
        }.onDisappear{
                //视图 完全 隐藏时回调【在下个页面的onAppear调用后再执行】
        }
    
    }
}

struct OtherView_Previews: PreviewProvider {
    static var previews: some View {
        OtherView()
    }
}


//使用UIKit的API设定TabBar相关的属性
//设置Tab显示的背景
//UITabBar.appearance().backgroundColor = .white
//设置未选中内容的颜色
//UITabBar.appearance().unselectedItemTintColor = .yellow

//提示未读标签的背景色
//UITabBarItem.appearance().badgeColor = .white
//未读提示的未选中/选中文本样式添加
//UITabBarItem.appearance().setBadgeTextAttributes([.foregroundColor:UIColor.red , .font:Font.system(size: 12)], for: .normal)
//UITabBarItem.appearance().setBadgeTextAttributes([.foregroundColor:UIColor.blue , .font:Font.system(size: 12)], for: .selected)

//设置TabItem文字和图片的偏移量
//UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)


//设置选中内容的颜色
//.tint(.green)


