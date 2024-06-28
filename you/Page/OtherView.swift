//
//  OtherView.swift
//  you
//
//  Created by 翁益亨 on 2024/6/28.
//

import SwiftUI

struct OtherView: View {
    var body: some View {
        NavigationLink(destination: WiFiView()){
            Text("跳转到WIFI")
        }.onAppear{
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
