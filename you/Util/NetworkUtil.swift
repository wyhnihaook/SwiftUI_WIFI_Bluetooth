//
//  NetworkUtil.swift
//  you
//  获取网络相关内容
//  Created by 翁益亨 on 2024/6/25.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
//CoreWLAN：MacOS系统专属扫描wifi信息
//import CoreWLAN

class NetworkUtil{
    // MARK: 获取当前设备连接的WiFi名称
    static func getCurrentWifiName()->String{
        var wifiName = ""
        let wifiInterfaces = CNCopySupportedInterfaces()
        guard wifiInterfaces != nil else {
            return wifiName
        }
        
        let interfaceArr = CFBridgingRetain(wifiInterfaces) as! [String]
        if interfaceArr.count > 0 {
            let interfaceName = interfaceArr[0] as CFString
            let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
            
            if ussafeInterfaceData != nil {
                let interfaceData = ussafeInterfaceData as! [String: Any]
                wifiName = interfaceData["SSID"]! as! String
            }
        }
        return wifiName
    }
    
    
    // MARK: 获取当前设备连接的WiFi
    static func getWiFiName() -> [NetworkInfo]? {
        if let interfaces: NSArray = CNCopySupportedInterfaces() {
            var networkInfos = [NetworkInfo]()
            for interface in interfaces {
                let interfaceName = interface as! String
                var networkInfo = NetworkInfo(interface: interfaceName,
                                              success: false,
                                              ssid: nil,
                                              bssid: nil)
                if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
                    networkInfo.success = true
                    networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
                    networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
                }
                networkInfos.append(networkInfo)
            }
            return networkInfos
        }
        return nil
    }
    
    struct NetworkInfo {
        var interface: String
        var success: Bool = false
        var ssid: String?
        var bssid: String?
    }
    
    
    //MARK: - 获取APP内配置过的WIFI列表。简单理解：是在app内指定连接的WIFI会出现在列表中
    static func getWifiList(resultCallBack: @escaping (Array<String>) -> Void){
        NEHotspotConfigurationManager.shared.getConfiguredSSIDs { ssids in
            //源码中获取的ssids是[String]格式，说明必定存在不为nil
            resultCallBack(ssids)
        }
    }
    
    //MARK: - 通过ssid删除一个配置
    static func deleteSSID(){
        
    }
    
    
    //MARK: - APP内连接指定的WIFI信息
    static func connectPasswordWIFI(ssid: String, password: String = ""){
        //如果是第一次连接就需要输入手机号码，如果是第二次快速连接直接使用本地持久化存储到密码
        var connectPassword = password
        if connectPassword.isEmpty{
            //从本地持久化存储的中获取密码，存在并且密码长度大于0
            guard let searchPassword = PersistentStorageManager.shared.getPasswordFromSSID(ssid: ssid) , searchPassword.count > 0 else{
                //没有检索到密码，可以提示用户连接失败，请重新输入密码并从配置的列表中移除
               return
            }
            //存在匹配密码，进行连接
            connectPassword = searchPassword
        }
        
        print(ssid,connectPassword)
        
        let hotmode = NEHotspotConfiguration(ssid: ssid, passphrase: connectPassword, isWEP: false)
        //只会连接一次这个热点，如果连接失败或者断开连接，将不会自动连接
        //默认是false，会保存wifi到配置中，如果设置true就不会保留配置信息
        hotmode.joinOnce = false
        NEHotspotConfigurationManager.shared.apply(hotmode){error in
            if let error = error as NSError? {
                  print("发生错误: \(error.localizedDescription), code: \(error.code)")
                  // 这里可以先简单处理或打印错误，之后再根据错误代码细化处理逻辑
              } else {
                  //这里本地持久化存储密码信息
                  PersistentStorageManager.shared.setSSIDWithPassword(ssid: ssid, password: connectPassword)
                  print("Wi-Fi配置已成功应用，但这不代表连接成功，需进一步检查网络状态。")
              }
        }
    }
    
    //MARK: - 扫描局域网
    //此函数应在应用程序启动时调用一次。
    //再次调用它将无效，并导致返回FALSE。
    static func scanLan(){
      
        let queue = DispatchQueue(label: "com.zai.you")
        let options:[String : NSObject] = [kNEHotspotHelperOptionDisplayName : "" as NSObject ]
        
        let result = NEHotspotHelper.register(options: options, queue: queue) { cmd in
            print("cmd")
            if cmd.commandType == .filterScanList{
                print(cmd.networkList as Any)
            }else{
                print("没有扫描到")
            }
        }
        print("result:\(result)")
    }

    
    static func supportWIFI(){
        if let wifiList = NEHotspotHelper.supportedNetworkInterfaces(){
            print(wifiList)
        }else{
            print("找不到")
        }

    }
}
