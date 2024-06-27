//
//  BluetoothDataView.swift
//  you
//
//  Created by 翁益亨 on 2024/6/27.
//

import SwiftUI

struct BluetoothDataView: View {
    
    @ObservedObject var bluetoothInfoData:BluetoothInfoData
    
    //创建内部管理数据对象
    @StateObject var model = BluetoothDataManager()
    
    var body: some View {
        List{
            Section("设备信息"){
                BluetoothRow(title: "设备名称", content: bluetoothInfoData.name)
                BluetoothRow(title: "设备状态", content: model.connceted ? "已连接" : "未连接")
                //外设发送到数据同步
                BluetoothRow(title: "接收信息", content: String(describing: model.heartRate?.measurement ?? 0))
            }
            
            Section("主动操作"){
                BluetoothRow(title: "连接当前设备").onTapGesture {
                    model.reConnect()
                }
                BluetoothRow(title: "断开连接").onTapGesture {
                    SharedData.bluejay.disconnect()
                }
            }
            
        }.navigationBarTitle(Text("蓝牙数据交互"), displayMode: .large)
            .onAppear{
                print("onAppear data")
                //注册连接状态的获取
                let manager = BluetoothConnectHelper()
                manager.binding(bluetoothManager: model)
                SharedData.bluejay.register(connectionObserver: manager)
                
                //订阅信息获取外设数据
                SharedData.bluejay.register(serviceObserver: BluetoothServiceHelper(bluetoothManager: model))
                
            }.onDisappear{
                //取消状态监听的注册
            }
    }
}

struct BluetoothDataView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothDataView(bluetoothInfoData:BluetoothInfoData(name: "123"))
    }
}


struct BluetoothRow : View{
    //标题
    let title: String
    //信息
    let content: String
    
    init(title: String, content: String = "") {
        self.title = title
        self.content = content
    }
    
    var body: some View{
        HStack{
            Text(title)
            Spacer()
            Text(content)
        }
    }
}
