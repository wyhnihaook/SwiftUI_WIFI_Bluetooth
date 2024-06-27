//
//  BluetoothServiceHelper.swift
//  you
//  蓝牙外设服务信息同步
//  Created by 翁益亨 on 2024/6/27.
//

import Foundation
import Bluejay

class BluetoothServiceHelper : ServiceObserver{
    
    //初始化回调信息实现，同步Manager管理类。调用内部的管理蓝牙方法
    var bluetoothManager:BluetoothBaseManager
    
    init(bluetoothManager: BluetoothBaseManager) {
        self.bluetoothManager = bluetoothManager
    }
    
    func didModifyServices(from peripheral: PeripheralIdentifier, invalidatedServices: [ServiceIdentifier]) {
        //发现外设的服务【服务    等同于     消息】
        //需要双端协商定义UUID对应的作用和数据，获取后同步数据
    }
    
    
}
