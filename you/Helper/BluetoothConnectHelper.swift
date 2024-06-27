//
//  BluetoothScanHelper.swift
//  you
//
//  Created by 翁益亨 on 2024/6/27.
//

import Foundation
import Bluejay

//创建连接帮助类匹配到内容
class BluetoothConnectHelper : ConnectionObserver, DisconnectHandler{
    
    //初始化回调信息实现，同步Manager管理类。调用内部的管理蓝牙方法
    var bluetoothManager:BluetoothBaseManager?
    
    
    func binding(bluetoothManager: BluetoothBaseManager) {
        self.bluetoothManager = bluetoothManager
    }
    
    //蓝牙连接回调相关信息
    func bluetoothAvailable(_ available: Bool) {
        if available{
            //识别到中心设备蓝牙可用，开始接收外部广播信息【外设的广播信息】
            //匹配管理类型
            switch bluetoothManager{
            case let manager as BluetoothManager:
                manager.scanHeartSensors()
            default:
                print("未知类型")
            }
            
        }else{
            //页面上展示对应因为蓝牙不可用无法识别的标识
        }
    }
    
    func connected(to peripheral: PeripheralIdentifier) {
        print("connected----:\(peripheral)")

        //完成连接之后的回调。根据业务需求处理：停止扫描、可以跳转新的页面去接受处理对应的操作信息等
        
        switch bluetoothManager{
            case let manager as BluetoothManager:
                manager.stopScanning()
            case let dataManager as BluetoothDataManager:
                //已经连接到回调，同步connect状态
                dataManager.initConnected(peripheral: peripheral)
            default:
                print("未知类型")

        }
        //注意：Connection deinitialized.日志表示的是队列中连接的task任务已经完成并完成回收，和真实连接情况没有关联
    }
    
    func didDisconnect(from peripheral: PeripheralIdentifier, with error: Error?, willReconnect autoReconnect: Bool) -> AutoReconnectMode {
        //断开连接之后的业务逻辑添加
        print("didDisconnect")

       
        
        //外设主动关闭之后回调不执行这里 TODO
        return .noChange
    }
    
}
