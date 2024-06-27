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
