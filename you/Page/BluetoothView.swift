//
//  BluetoothView.swift
//  you
//  蓝牙扫描页面内容【当应用退到后台时暂停扫描，回到前台时开启扫描】
//  Created by 翁益亨 on 2024/6/26.
//

import SwiftUI
import Bluejay

struct BluetoothView: View {
    //共享的数据获取
    @EnvironmentObject var sharedData : SharedData
    
    //创建内部管理数据对象
    @StateObject var model = BluetoothManager()
        
    
    var body: some View {
        //选择连接到设备之后自动跳转页面
            List{
        
                Section("已连接设备") {
                    if model.selectedSensor != nil {
                        //顶级页面使用NavigationView之后，后续页面可用直接使用NavigationLink进行跳转
                        NavigationLink {
                            //跳转时携带的参数构建
                            let bluetoothInfoData = BluetoothInfoData(name: model.selectedSensor!.name)
                            BluetoothDataView(bluetoothInfoData:bluetoothInfoData)
                        } label: {
                            //这里保证已经连接才能跳转页面
                            //页面会销毁影响状态
                            HStack{
                                Text(model.selectedSensor!.name)
                                Spacer().frame(width:100)
                                Text(model.connceted ? "已连接":"未连接").font(.system(size: 12))
                                    .foregroundColor(model.connceted ? .red : .gray)
                            }
                        }

                    }
                }
                
                
                Section("其他设备") {
                    ForEach(model.sensors,id: \.self.peripheralIdentifier.uuid) { sensor in
                        Text(sensor.peripheralIdentifier.name).onTapGesture {
                            //点击链接蓝牙功能
                            model.connectBluetooth(device: sensor)
                        }
                    }
                }
                
            }
            .listStyle(.grouped)
            .navigationBarTitle(Text("蓝牙"), displayMode: .large).onAppear{
            //视图初始化创建[BluetoothScanHelper]遵守协议的帮助类，用于验证蓝牙是否可用并开启扫描等业务
            //开始扫描，列表展示设备内容。通过点击方法进行连接
            SharedData.bluejay.register(connectionObserver: model)
            
        }.onDisappear{
            //视图销毁
            SharedData.bluejay.unregister(connectionObserver: model)
            
            //页面关闭后，停止扫描功能
            SharedData.bluejay.stopScanning()
        }
    }
}

struct BluetoothView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothView()
    }
}


