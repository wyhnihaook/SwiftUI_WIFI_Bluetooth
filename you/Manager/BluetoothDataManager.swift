//
//  BluetoothDataManager.swift
//  you
//  蓝牙【数据交互】管理类。注意：使用前请先到Info中去注册申请蓝牙权限的提示弹窗，不然会崩溃
//  Created by 翁益亨 on 2024/6/27.
//

import Foundation
import Bluejay


let heartRateCharacteristic = CharacteristicIdentifier(
    uuid: "2A37",
    service: ServiceIdentifier(uuid: "180D")
)

let normalCharacteristic = CharacteristicIdentifier(
    uuid: "83B4A431-A6F1-4540-B3EE-3C14AEF71A04",
    service: ServiceIdentifier(uuid: "CED261B7-F120-41C8-9A92-A41DE69CF2A8")
)

let pairingCharacteristic = CharacteristicIdentifier(
    uuid: "E4D4A76C-B9F1-422F-8BBA-18508356A145",
    service: ServiceIdentifier(uuid: "16274BFE-C539-416C-9646-CA3F991DADD6")
)

class BluetoothDataManager : BluetoothBaseManager {
    
    //同步到外部显示的数据内容
    @Published var heartRate: HeartRateMeasurement?
    
    //普通数据内容同步
    @Published var normalData : String?
    
    //主动获取的数据内容
    @Published var activeData : String?
    
    
    //MARK: - 主动获取外设数据
    func getData(){
        bluejay.read(from: pairingCharacteristic) { [weak self] (result: ReadResult<Data>) in
            guard let weakSelf = self else {
                return
            }

            switch result {
            case .success(let data):
                weakSelf.activeData = String(data: data, encoding: .utf8) ?? ""
                print("Pairing success: \(String(describing: weakSelf.activeData))")
            case .failure(let error):
                print("Pairing failed with error: \(error.localizedDescription)")
            }
        }
    }

    
    func listen(to characteristic: CharacteristicIdentifier) {
        //设定自定义传输类型。这里注意ReadResult的泛型，匹配外设传递的类型
        //ReadResult内部逻辑转化类型代码需要对应扩展
        //普通Data格式传输接收【所有传输的数据都可以使用Data格式接收后转化】
        if characteristic == heartRateCharacteristic {
            bluejay.listen(
                to: heartRateCharacteristic,
                multipleListenOption: .replaceable) { [weak self] (result: ReadResult<HeartRateMeasurement>) in
                    guard let weakSelf = self else {
                        return
                    }

                    switch result {
                    case .success(let heartRate):
                        weakSelf.heartRate = heartRate
                    case .failure(let error):
                        print("Failed to listen to heart rate with error: \(error.localizedDescription)")
                    }
            }
        }else if characteristic == normalCharacteristic {
            bluejay.listen(to: normalCharacteristic, multipleListenOption: .replaceable) { [weak self](result: ReadResult<String>) in
                guard let weakSelf = self else {
                    return
                }
                switch result {
                case .success(let data):
                    print("Dittojay normal.:\(data)")
                    weakSelf.normalData = data
                case .failure(let error):
                    print("Failed to listen to heart rate with error: \(error.localizedDescription)")
                }
            }
        }
    }

    func endListen(to characteristic: CharacteristicIdentifier) {
        bluejay.endListen(to: characteristic) { result in
            switch result {
            case .success:
                print("End listen to \(characteristic.description) is successful")
            case .failure(let error):
                print("End listen to \(characteristic.description) failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - 连接状态识别成功后进行初始化操作
    func initConnected(peripheral: PeripheralIdentifier){
        connceted = true

        selectedSensor = peripheral
        //订阅服务，特征值变化后会实时回调到中心设备的方法中以获取服务传递的特征。获取特征的value值【实际上关心的数据】
        listen(to: heartRateCharacteristic)
        listen(to: normalCharacteristic)
    }
    
    
    //MARK: - 连接当前设备
    func reConnect(){
        weak var weakSelf = self
        bluejay.connect(selectedSensor!, timeout: .seconds(15)) { result in
            switch result {
            case .success:
                weakSelf?.connceted = true
                //执行到这里之后发现没有走注册的回调
//                weakSelf?.listen(to: heartRateCharacteristic)
                print("Connection attempt to: \(String(describing: weakSelf?.selectedSensor!.description)) is successful")
            case .failure(let error):
                print("Failed to connect to: \(weakSelf?.selectedSensor!.description ?? "") with error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - 断开设备信息
    func disconnect(){
        bluejay.disconnect()
    }
}

extension BluetoothDataManager : ConnectionObserver, ServiceObserver {
    //MARK: - 实现【连接、服务】协议
    ///蓝牙连接回调相关信息
    func bluetoothAvailable(_ available: Bool) {
        if available{
            //识别到中心设备蓝牙可用，开始接收外部广播信息【外设的广播信息】
        }else{
            //页面上展示对应因为蓝牙不可用无法识别的标识
        }
    }
    
    ///关注扫描API的调用：manager.scanForPeripherals
    func connected(to peripheral: PeripheralIdentifier) {
        print("connected----:\(peripheral)")

        //完成连接之后的回调。这里是通过
        initConnected(peripheral: peripheral)
    }
    
    //这里的断开信息回调需要和注册的【disconnectHandler】进行区分
    func disconnected(from peripheral: PeripheralIdentifier) {
        //连接断开之后的回调
        connceted = false
    }
    
    func didModifyServices(from peripheral: PeripheralIdentifier, invalidatedServices: [ServiceIdentifier]) {
        //当外围设备删除或添加服务时调用。【服务    等同于     需要获取的消息】
        //该方法的作用主要是用来移除无效的服务【处理服务被移除的情况】
        print("设备信息：\(invalidatedServices)")
        //判断无效列表中是否包含普通接受信息。如果包含需要取消订阅信息。理论上每一个添加的操作都需要对应移除的操作
        if invalidatedServices.contains(where: { invalidatedServiceIdentifier -> Bool in
            invalidatedServiceIdentifier == normalCharacteristic.service
        }){
            endListen(to: normalCharacteristic)
        }
        
        if invalidatedServices.isEmpty{
            //说明是新增的服务，这里设计只能对一个服务进行移除和添加处理
            //【实际上一个服务可以有多个特征。所以使用一个服务统一管理特征行为也是可以的】
            //设计的回调也只满足预知服务并且只有一个移除添加的情况
            listen(to: normalCharacteristic)
        }
    }
}


struct HeartRateMeasurement: Receivable {

    private var flags: UInt8 = 0
    private var measurement8bits: UInt8 = 0
    private var measurement16bits: UInt16 = 0
    private var energyExpended: UInt16 = 0
    private var rrInterval: UInt16 = 0

    private var isMeasurementIn8bits = true

    var measurement: Int {
        return isMeasurementIn8bits ? Int(measurement8bits) : Int(measurement16bits)
    }

    init(bluetoothData: Data) throws {
        flags = try bluetoothData.extract(start: 0, length: 1)

        isMeasurementIn8bits = (flags & 0b00000001) == 0b00000000

        if isMeasurementIn8bits {
            measurement8bits = try bluetoothData.extract(start: 1, length: 1)
        } else {
            measurement16bits = try bluetoothData.extract(start: 1, length: 2)
        }
    }

}
