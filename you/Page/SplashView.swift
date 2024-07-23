//
//  SplashView.swift
//  you
//  欢迎页面。跳转登录/首页逻辑处理【结合LeanCloud实现】
//  Created by 翁益亨 on 2024/7/9.
//

import SwiftUI
import LeanCloud

struct SplashView: View {
    @State var isLoginActive = false
    @State var isNeedLoginActive = false

    var body: some View {
        NavigationView{
            VStack{
                
                Text("欢迎页面")
                
                NavigationLink(destination: OtherView(),isActive: $isLoginActive) {
                }
                
                NavigationLink(destination: LoginView(),isActive: $isNeedLoginActive) {
                    //不设置显示内容，直接由页面逻辑处理跳转激活状态
                }
            }
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                
                //判断是否存在本地缓存的登录信息
                //对应激活active属性进行自动跳转
                if LCApplication.default.currentUser != nil{
                    //存在的情况
                    print("111")
                    isLoginActive = true
                }else{
                    //不存在的情况
                    print("222")
                    isNeedLoginActive = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
