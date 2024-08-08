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
    @State private var showToast = false
    @AppStorage("userScheme") var userTheme: Theme = .systemDefault
    
    //抽屉菜单栏显示控制，同步给FileView页面来控制
    @State private var isSidebarVisible = false
    
    //抽屉菜单栏中选中的展示内容【个数通过网络请求后重新赋值】- 内部同步【实际上要在这里同步全部文件个数 + 未分类个数】内部创建对应的文件夹进行存放
    @State private var fileSource : FileSource = .ALLFILES(count: 0)
    
    var body: some View {
            //【TabBar自定义的控件最大的问题就是不能缓存当前的TabBar页面信息。只能通过系统的TabView结合tag标签来实现。底部自定义，TabView只是作为展示内容的容器】
            ZStack(alignment:Alignment(horizontal: .center, vertical: .bottom)){
               
                //由于TabView默认自带的底部边距
                //这里要关注NavigationView跳转到当前页面可能会出现顶部标题栏占位的问题。请按照本文.navigationxx设置。可以解决页面切换后才使得标题栏占位消失的问题！！！！！！！！
                //最后一个tab的.navigationBarTitle("", displayMode: .inline)属性设置至关重要！！！！
                TabView(selection: $selection) {
                    
                    FileView(isSidebarVisible:$isSidebarVisible, fileSource: $fileSource).tag(HomeTabBar.file.rawValue)
                    MineView().tag(HomeTabBar.mine.rawValue)
                    
                }.navigationBarHidden(true)
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
                }
                //通过主题类型来展示对应的颜色
                .background(userTheme.tabBgColor).overlay(
                    //overlay在基础视图上叠加额外布局信息
                    
                    //底部占位按钮信息，通过偏移量达到效果
                    ZStack {
                        //底部TabBar的自定义高度为50.这里设置80后自动顶出位置
                        Circle()
//                            .foregroundColor(.white)
                            .frame(width: 54.0, height: 54.0)

                        Image("icon_mic")
                            .resizable()
                            .frame(width: 50.0, height: 50.0)
                    }
                        .offset(x:0,y:-15),alignment: .top)
                
                
                SideMenu(isSidebarVisible: $isSidebarVisible, fileSource:$fileSource)
                
            }.navigationBarHidden(true)
        //应用的主题色设置，脱离系统控制
        .preferredColorScheme(userTheme.colorCheme)
            .toast(isPresenting: $showToast, duration: 2.0, tapToDismiss:false){
                AlertToast(type: .regular,title: "保存完成",style: .style(backgroundColor:Color(r: 0, g: 0, b: 0,a: 0.75),titleColor: .white))


                // `.alert` is the default displayMode【没有背景内容】
    //            AlertToast(type: .regular, title: "Message Sent!")
                
                //Choose .hud to toast alert from the top of the screen【从顶部弹出到标题栏位置】
    //            AlertToast(displayMode: .hud, type: .regular, title: "Message Sent!")
                
                //Choose .banner to slide/pop alert from the bottom of the screen【动画效果滑入滑出】
    //            AlertToast(displayMode: .banner(.slide), type: .regular, title: "Message Sent!")
            } 
           
        .onAppear{
            //视图 完全 展示在界面上时回调【页面跳转后返回会调用】
            
            //注意：toast不能在初始化就设置显示true，会导致定时器无法执行到消失
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
//                showToast = true
//            }
            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            print("documentsDirectory:\(documentsDirectory)")
            print("folder:\(Folder.home)")
            print("folder:\(Folder.root)")
            print("folder:\(Folder.documents)")

            FileUtil.createFolder()
            FileUtil.getFileListFilterTime()
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


