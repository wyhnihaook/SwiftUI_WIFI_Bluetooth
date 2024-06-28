//
//  ContentView.swift
//  you
//
//  Created by 翁益亨 on 2024/6/25.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        NavigationView{
            List{
                //设置分节内容
                Section("WIFI功能") {
                    NavigationLink(destination: WiFiView()) {
                        PageRow(title: "WIFI相关", subTitle: "提供查找、记录并自动连接的功能")
                    }
                }
                
                Section("蓝牙功能") {
                    NavigationLink(destination: BluetoothView()) {
                        PageRow(title: "蓝牙相关", subTitle: "提供查找、连接、通信、记录并自动连接的功能")
                    }
                }
                
                Section("其他功能") {
                    NavigationLink(destination: OtherView()) {
                        PageRow(title: "其他相关", subTitle: "- -")
                    }
                }
            }
            //设置分组模式，默认适配模式根据内容加载
            .listStyle(.grouped)
            //提供列表的大标题信息
            .navigationBarTitle(Text("示例"), displayMode: .large)
            .navigationBarItems(leading: Text("Left").navBarTextStyle(color:.blue), trailing: Text("Right").navBarTextStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
