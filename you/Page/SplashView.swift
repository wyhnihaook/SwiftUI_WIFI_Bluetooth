//
//  SplashView.swift
//  you
//  欢迎页面
//  Created by 翁益亨 on 2024/7/9.
//

import SwiftUI

struct SplashView: View {
    @State var isActive = false
    
    var body: some View {
        NavigationView{
            NavigationLink(destination: OtherView(),isActive: $isActive) {
                 Text("自动跳转的欢迎页面")
            }
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                isActive = true
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
