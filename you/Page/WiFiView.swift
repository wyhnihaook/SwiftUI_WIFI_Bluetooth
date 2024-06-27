//
//  WiFiView.swift
//  you
//  WiFi管理页面
//  Created by 翁益亨 on 2024/6/25.
//

import SwiftUI

struct WiFiView: View {
    @State private var connectedWifiName = ""
    @StateObject private var locationManager = LocationManager()
    
    @State private var recordWifiList:[String] = []

    var body: some View {
        List{
        
            Section("已连接网络") {
                Text(connectedWifiName)
            }
            
            Section("我的网络") {
                //已经连接过的网络
                ForEach(recordWifiList,id:\.self){
                    item in
                    Text(item).onTapGesture {
                        //点击快速连接已经记录的wifi
                        //失败的情况，需要从配置中移除
                        NetworkUtil.connectPasswordWIFI(ssid: item)
                    }
                }
            }
            
            Section("其他网络") {
                Text("需要申请授权，三周左右才会回复申请结果")
            }
            
        }.onAppear{
            //获取已经连接过的WIFI信息
            NetworkUtil.getWifiList{ssids in
                recordWifiList = ssids
            }
            
            NetworkUtil.supportWIFI()
            
            //页面第一次加载/显示时调用获取数据
            //这里授权，只有开启了精确定位才能读取wifi信息
            locationManager.checkLocationAuthorization{result in
                if result {
                    connectedWifiName = NetworkUtil.getCurrentWifiName()
                    
                }else{
                    print("fail")
                }
            }
        }.onDisappear{
            locationManager.stopUpdateLocation()
        }
        .listStyle(.grouped)
        .navigationBarTitle(Text("无线局域网"), displayMode: .large)
    }
}

struct WiFiView_Previews: PreviewProvider {
    static var previews: some View {
        WiFiView()
    }
}
