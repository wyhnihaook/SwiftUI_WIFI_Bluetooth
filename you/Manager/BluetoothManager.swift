//
//  BluetoothManager.swift
//  you
//  蓝牙【扫描/连接】管理类。注意：使用前请先到Info中去注册申请蓝牙权限的提示弹窗，不然会崩溃
//  Created by 翁益亨 on 2024/6/26.
//

import Foundation
import Bluejay
///管理类中创建可管理的数据结构，外部通过创建该实例获取对应数据源信息
class BluetoothManager : BluetoothBaseManager{
    
    //MARK: - 需要同步到界面的数据信息
    
    ///扫描到的蓝牙设备信息
    @Published var sensors: [ScanDiscovery] = []
    
    
    //MARK: - 扫描设备功能
    func scanHeartSensors(){
        if !bluejay.isScanning && !bluejay.isConnecting && !bluejay.isConnected {
            //如果需要指定匹配的设备，那么就要匹配设备所广播的服务UUID。设定完毕之后只会回调指定设备信息
            //经过实践发现如果不置顶相关的服务UUID，那么周边的很多支持蓝牙的设备将会被扫描进入。
            //例如：MAC电脑、Android手机以及一大部分No Name的设备
            //即使过滤了No Name【设备列表和系统蓝牙识别的结果列表完全不一致】
            //根据连接固定蓝牙的需求设定，这里就通过UUID去做匹配信息连接【真实设备之间互相影响的问题需要实践】
            
            //这里设定的UUID为蓝牙外设广播的UUID信息
            let heartRateService = ServiceIdentifier(uuid: "180D")
            
            bluejay.scan(
                allowDuplicates: true,
                //匹配的服务UUID，可指定多个
                serviceIdentifiers: [heartRateService],
                discovery: { [weak self] _, discoveries -> ScanAction in
                    guard let weakSelf = self else {
                        return .stop
                    }
                    
                    weakSelf.sensors = discoveries

                    return .continue
                },
                expired: { [weak self] lostDiscovery, discoveries -> ScanAction in
                    guard let weakSelf = self else {
                        return .stop
                    }

                    print("Lost discovery: \(lostDiscovery)")

                    weakSelf.sensors = discoveries

                    return .continue
                },
                stopped: { _, error in
                    if let error = error {
                        print("Scan stopped with error: \(error.localizedDescription)")
                    } else {
                        print("Scan stopped without error")
                    }
                })
        }
    }
    
    //MARK: - 链接蓝牙功能
    ///会回调到链接成功的监听事件中[BluetoothScanHelper]
    func connectBluetooth(device: ScanDiscovery){
        ///点击后将搜索的结果列表中过滤相同的展示数据，不显示
        selectedSensor = device.peripheralIdentifier
        weak var weakSelf = self
        bluejay.connect(selectedSensor!, timeout: .seconds(15)) { result in
            switch result {
            case .success:
                weakSelf?.connceted = true
                print("Connection attempt to: \(String(describing: weakSelf?.selectedSensor!.description)) is successful")
            case .failure(let error):
                print("Failed to connect to: \(weakSelf?.selectedSensor!.description ?? "") with error: \(error.localizedDescription)")
            }
        }
    }
    
    
    //MARK: - 暂停扫描设备
    func stopScanning(){
        bluejay.stopScanning()
    }
}

extension BluetoothManager : ConnectionObserver, DisconnectHandler{
    //蓝牙连接回调相关信息
    func bluetoothAvailable(_ available: Bool) {
        if available{
            //识别到中心设备蓝牙可用，开始接收外部广播信息【外设的广播信息】
            scanHeartSensors()
            
        }else{
            //页面上展示对应因为蓝牙不可用无法识别的标识
        }
    }
    
    ///关注扫描API的调用：manager.scanForPeripherals
    func connected(to peripheral: PeripheralIdentifier) {
        //蓝牙开启扫描时，如果检测到当前存在已经连接的情况，则直接返回连接的外设信息
        print("connected2----:\(peripheral)")
        selectedSensor = peripheral

        //完成连接之后的回调。根据业务需求处理：停止扫描、可以跳转新的页面去接受处理对应的操作信息等
        //注册回调完毕之后如果检测连接状态是已连接 - 还是会执行这里，主要是用于体现当前的状态回调
        stopScanning()
        
        //注意：Connection deinitialized.日志表示的是队列中连接的task任务已经完成并完成回收，和真实连接情况没有关联
    }
    
    
    //要获取该回调需要注册对应方法【registerDisconnectHandler】
    func didDisconnect(from peripheral: PeripheralIdentifier, with error: Error?, willReconnect autoReconnect: Bool) -> AutoReconnectMode {
        //断开连接之后的业务逻辑添加
        print("didDisconnect")

        return .noChange
    }
}
