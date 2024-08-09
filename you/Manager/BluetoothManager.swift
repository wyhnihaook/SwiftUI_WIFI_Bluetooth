//
//  BluetoothManager.swift
//  you
//  蓝牙【扫描/连接】管理类。注意：使用前请先到Info中去注册申请蓝牙权限的提示弹窗，不然会崩溃
//  Created by 翁益亨 on 2024/6/26.
//

import Foundation
import Bluejay

//MARK: - 和外设协商好的基本信息

let heartRateCharacteristic = CharacteristicIdentifier(
    uuid: "2A37",
    service: ServiceIdentifier(uuid: "180D")
)

let normalCharacteristic = CharacteristicIdentifier(
    uuid: "83B4A431-A6F1-4540-B3EE-3C14AEF71A04",
    service: ServiceIdentifier(uuid: "CED261B7-F120-41C8-9A92-A41DE69CF2A8")
)

//文件同步特征处理
let fileCharacteristic = CharacteristicIdentifier(
    uuid: "83B4A431-A6F1-4540-B3EE-3C14AEF71A01",
    service: ServiceIdentifier(uuid: "CED261B7-F120-41C8-9A92-A41DE69CF2A1")
)

let fileContiuneCharacteristic = CharacteristicIdentifier(
    uuid: "83B4A431-A6F1-4540-B3EE-3C14AEF71A02",
    service: ServiceIdentifier(uuid: "CED261B7-F120-41C8-9A92-A41DE69CF2A2")
)

let pairingCharacteristic = CharacteristicIdentifier(
    uuid: "E4D4A76C-B9F1-422F-8BBA-18508356A145",
    service: ServiceIdentifier(uuid: "16274BFE-C539-416C-9646-CA3F991DADD6")
)


///管理类中创建可管理的数据结构，外部通过创建该实例获取对应数据源信息
class BluetoothManager : BluetoothBaseManager{
    //MARK: - 数据同步
    //同步到外部显示的数据内容
    @Published var heartRate: HeartRateMeasurement?
    
    //普通数据内容同步 - 首先同步的数据需要展示内容
    @Published var normalData : String?
    
    //主动获取的数据内容
    @Published var activeData : String?
    
    //接收的文件数据。切换数据接收时需要清空Data
    var receivedFileData : Data = Data()
    
    
    //MARK: - 蓝牙连接需要同步到界面的数据信息
    
    ///扫描到的蓝牙设备信息
    @Published var sensors: [ScanDiscovery] = []
    
    
    //MARK: - 扫描设备功能
    func scanHeartSensors(){
        if !bluejay.isBluetoothAvailable{
            //如果无效就不进行扫描【蓝牙不可用】
            return
        }
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

extension BluetoothManager : ConnectionObserver, DisconnectHandler, ServiceObserver{
    //蓝牙连接回调相关信息
    func bluetoothAvailable(_ available: Bool) {
        if available{
            //识别到中心设备蓝牙可用，开始接收外部广播信息【外设的广播信息】
            //由当前页面的生命周期onAppear开始触发
//            scanHeartSensors()
            
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
        
        //蓝牙连接完毕之后要订阅对应的特征信息，用于接收或者发送交互数据
        initConnected(peripheral: peripheral)
    }
    
    //这里的断开信息回调需要和注册的【disconnectHandler】进行区分
    func disconnected(from peripheral: PeripheralIdentifier) {
        //连接断开之后的回调
        print("断开链接")
        connceted = false
    }
    
    //要获取该回调需要注册对应方法【registerDisconnectHandler】
    func didDisconnect(from peripheral: PeripheralIdentifier, with error: Error?, willReconnect autoReconnect: Bool) -> AutoReconnectMode {
        //断开连接之后的业务逻辑添加
        print("断开链接didDisconnect")

        return .noChange
    }
    
    //订阅服务相关回调
    func didModifyServices(from peripheral: PeripheralIdentifier, invalidatedServices: [ServiceIdentifier]) {
        //例如：外设关闭了，无效的服务新增了对应的类型会返回。可以是主动关闭或者是外设关闭了渠道内容
        
        //当外围设备删除或添加服务时调用。【服务    等同于     需要获取的消息】
        //该方法的作用主要是用来移除无效的服务【处理服务被移除的情况】
        print("设备信息：\(invalidatedServices)")
        //判断无效列表中是否包含普通接受信息。如果包含需要取消订阅信息。理论上每一个添加的操作都需要对应移除的操作
        if invalidatedServices.contains(where: { invalidatedServiceIdentifier -> Bool in
            invalidatedServiceIdentifier == normalCharacteristic.service
        }){
//            endListen(to: normalCharacteristic)
        }
        
        //说明已经重新连接上了一个外设服务【这里要注意，监听的方法必须配合移除监听的方法一起使用，不然会崩溃】
        //最好的方式就是不处理失效的服务，如果服务重新连接直接使用缓存内的服务重新尝试连接即可
        
        //这里要注意：外设移除后重启，那么这里会尝试连接执行回调 connected 方法，重新从缓存中获取对应的服务信息
        if invalidatedServices.isEmpty{
            //说明是新增的服务，这里设计只能对一个服务进行移除和添加处理
            //【实际上一个服务可以有多个特征。所以使用一个服务统一管理特征行为也是可以的】
            //设计的回调也只满足预知服务并且只有一个移除添加的情况
//            listen(to: normalCharacteristic)
        }
    }
}


//MARK: - 接受数据功能扩展
extension BluetoothManager{
    
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
    
    //监听外设的特征变化
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
                        print("heartRate:\(heartRate)")
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
                    //这里去获取JSON格式的字符串数据后，转化为结构体后处理内容
                    weakSelf.normalData = data
                    
                    //获取当前的信息内容进行处理
                    if let fileInformation:FileInformation = decodeJson(from: data) {
                        //这里的fileSize是用来判断是否完成了Data类型数据的传输，完成之后开始保存到本地文件内容
                        print("fileName: \(fileInformation.fileName),fileCount:\(fileInformation.fileSize)")
                    
                    }
                    
                case .failure(let error):
                    print("Failed to listen to heart rate with error: \(error.localizedDescription)")
                }
            }
        }else if characteristic == fileCharacteristic {
            bluejay.listen(to: fileCharacteristic, multipleListenOption: .replaceable) { [weak self](result: ReadResult<Data>) in
                guard let weakSelf = self else {
                    return
                }
                switch result {
                case .success(let data):
                    //使用数组缓存分段到文件数据之后，达到上限再进行本地存储
                    //使用静态的数据：次数2196 总大小为2196*20 -> 蓝牙设备侧设定的数据 来标识【后期联动时从FileInformation同步而来】
                    
                    
                    //测试MTU上限比较小，例如：290.这里分段20进行处理
                    print("weakSelf.receivedFileData:\(weakSelf.receivedFileData.count)")
                    print("data :\(data)")
                    weakSelf.receivedFileData.append(data)
                    
                    //这边接收到一次之后再次进行二次传输
                    //避免MTU【最大传输单元】
                    
                    if weakSelf.receivedFileData.count >= 2196*20{
                        //完成所有读取的内容.转存到本地对应的目录中
                        //转存过程没有问题，要注意外设同步过来的Data类型数据不能缺失！！！！
                        let fileURL = FileUtil.saveFileToDirectory(path: audioDirectory, fileName: "测试Test.mp3")
                        
                        do{
                            try weakSelf.receivedFileData.write(to: fileURL)
                            print("保存成功")
                        }catch{
                            print("保存到本地文件失败")
                        }
                    }else{
                        //向外设【蓝牙设备发送通知，实际上是写入数据触发回调】-> 通知继续发送文件Data数据请求
//                        let notifyData = "continue".toBluetoothData()
//                        weakSelf.getFileData()
                        
                    }
                    
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
        listen(to: fileCharacteristic)
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

