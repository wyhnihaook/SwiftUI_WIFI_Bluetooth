//
//  BluetoothBaseManager.swift
//  you
//
//  Created by 翁益亨 on 2024/6/27.
//

import Foundation
import Bluejay

class BluetoothBaseManager : ObservableObject{
//    var bluejay:Bluejay{
//        get{
//            SharedData.bluejay
//        }
//    }
    ///创建蓝牙管理类的唯一实例
    let bluejay = Bluejay()
    
    ///当前选中的设备封装名称和对应服务的UUID
    @Published var selectedSensor: PeripheralIdentifier?
    ///点击连接的状态同步，默认未连接。用于界面显示
    @Published var connceted: Bool = false
    
}
