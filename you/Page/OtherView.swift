//
//  OtherView.swift
//  you
//  注意badge属性在iOS15以上才生效
//  默认的TabView无法满足-自定义View处理
//  Created by 翁益亨 on 2024/6/28.
//

import SwiftUI

struct OtherView: View {
    @State private var selection: Item = .file
    @State private var visibility: TabBarVisibility = .visible
    
    private enum Item: Int, Tabbable {
        case file = 0
        case mine
        
        var icon: String {
            switch self {
                case .file: return "icon_file_unselect"
                case .mine: return "icon_file_unselect"
               
            }
        }
        
        var selectedIcon: String {
            switch self {
                case .file: return "icon_file_select"
                case .mine: return "icon_file_select"
               
            }
        }
        
        
        var title: String {
            switch self {
                case .file: return "文件"
                case .mine: return "我"
            }
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .bottom){
                TabBar(selection: $selection,visibility: $visibility) {
                    //隐藏底部TabBar内容功能
    //                Button {
    //                    withAnimation {
    //                        visibility.toggle()
    //                    }
    //                } label: {
    //                    Text("Hide/Show TabBar")
    //                }
    //                .tabItem(for: Item.file)
                    
                    FileView()
                    .tabItem(for: Item.file)
                        
                    MineView()
                        .tabItem(for: Item.mine)
                }.tabBar(style: CustomTabBarWhiteStyle())
                .tabItem(style: CustomTabItemNormalStyle())
                
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
                .offset(x:0,y:-20)
                .visibility(self.visibility)
            }
        }
        .onAppear{
            //视图 完全 展示在界面上时回调【页面跳转后返回会调用】
            
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
