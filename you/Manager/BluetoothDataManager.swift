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

class BluetoothDataManager : BluetoothBaseManager{
    
    //同步到外部显示的数据内容
    @Published var heartRate: HeartRateMeasurement?

    
    func listen(to characteristic: CharacteristicIdentifier) {
        //设定自定义传输类型
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
        }
        
        //普通Data格式传输接收【所有传输的数据都可以使用Data格式接收后转化】
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
        //订阅服务，获取服务传递的特征。获取特征的value值【实际上关心的数据】
        listen(to: heartRateCharacteristic)
//        listen(to: chirpCharacteristic)
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
