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
                //订阅通过数据变化同步，外设发送到数据同步【自定义数据结构每个数据源转化为Data类型添加到Data中传递】
                BluetoothRow(title: "接收自定义心跳信息", content: String(describing: model.heartRate?.measurement ?? 0))
                
                //订阅通过数据变化同步，获取Data直接能通过字符串转换结果的普通数据信息
                BluetoothRow(title: "接收普通信息", content: model.normalData ?? "0")
                
                //主动从外设中获取
                BluetoothRow(title: "点我主动去查询外设信息", content: model.activeData ?? "- -").onTapGesture {
                    model.getData()
                }
            }
            
            Section("主动操作"){
                BluetoothRow(title: "连接当前设备").onTapGesture {
                    model.reConnect()
                }
                BluetoothRow(title: "断开连接").onTapGesture {
                    model.disconnect()
                }
                BluetoothRow(title: "取消心跳特征的订阅").onTapGesture {
                    model.endListen(to: heartRateCharacteristic)
                }
                BluetoothRow(title: "订阅心跳特征").onTapGesture {
                    model.listen(to: heartRateCharacteristic)
                }
                BluetoothRow(title: "取消接收普通特征的订阅").onTapGesture {
                    model.endListen(to: normalCharacteristic)
                }
                BluetoothRow(title: "订阅普通特征").onTapGesture {
                    model.listen(to: normalCharacteristic)
                }
            }
            
        }.navigationBarTitle(Text("蓝牙数据交互"), displayMode: .large)
            .onAppear{
                //注册连接状态的获取
//                SharedData.bluejay.register(connectionObserver: model)
//
//                //订阅信息获取外设数据
//                SharedData.bluejay.register(serviceObserver: model)
                
            }.onDisappear{
                //取消状态监听的注册
//                SharedData.bluejay.unregister(connectionObserver: model)
//                
//                SharedData.bluejay.unregister(serviceObserver: model)
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
