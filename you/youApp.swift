//
//  youApp.swift
//  you
//
//  Created by 翁益亨 on 2024/6/25.
//

import SwiftUI
import Bluejay
import AudioKit
import AVFoundation
import RevenueCat
import LeanCloud

//声明全局静态产量
let fileManager = FileManager.default
let audioDirectory : String = "AudioDirectory"


@main
struct youApp: App {
    //共享数据创建
    let sharedData = SharedData()
  
    init(){
        //这里执行全局内容信息，标识APP已经初始化
        //等同于 didFinishLaunchingWithOptions
        do {
            //初始化LeanCloud的网络配置。可能需要时间，在限定的时间内发起网络请求会提示
            //LCError(code: 1, reason: "应用初始化失败，请两分钟后重试。")
            try LCApplication.default.set( id: "3bZWAMygwKEmyMt14w2JXgpU-gzGzoHsz",
               key: "3BntWK7Y24faYDAaJ5Lnx9Pe",
               serverURL: "https://api-leancloud.calamari.cn")
            
            //初始化RevenueCat 收入猫SDK，用于内购。可关联当前登录用户的信息【例如：数据库中的用户ID和支付的用户ID相同】
            Purchases.logLevel = .debug
//            Purchases.configure(withAPIKey: "", appUserID: "")
            Purchases.configure(withAPIKey: "appl_LnrVvTDNsZebnErStTEPrzBivQA")
            
            //在登录后获取对应的用户ID更新.【注意执行在异步子线程中】
//            updateUserId("1")
        
            
            //新建沙盒目录存储数据
            FileUtil.createDirectory(path: audioDirectory)
            
            //初始化网络配置
            var config = NetworkConfiguration(baseURL: URL(string:"https://www.baidu.com/"))
            NetworkManager.default.configuration = config
            
            //初始化音频相关设置
            Settings.bufferLength = .short
            try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(Settings.bufferLength.duration)
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord,
                                                            options: [.defaultToSpeaker, .mixWithOthers, .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
            
            //蓝牙开启
            SharedData.bluejay.start()
        } catch let err {
            print(err)
        }
        
    }
    
    private func updateUserId(id: String) async throws  -> (customerInfo: CustomerInfo, created: Bool){
            // 模拟从 API 获取数据
        return  try await Purchases.shared.logIn(id)
    }

    
    //14.0版本：可跟踪应用程序的状态：ScenePhase。配合WindowGroup使用【整个应用】
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
//            ContentView()
//              OtherView()
            SplashView().implementPopupView(config: configurePopup)
//            MindMapView()
//            AppNavBarView()
                .environmentObject(sharedData)
        }.onChange(of: scenePhase) { newValue in
            switch newValue{
            case .active:
                ///扫码界面打开时识别
                print("应用在前台展示，每次切换应用会多次执行")
            case .inactive:
                ///扫码界面不活动之后需要关闭扫码功能
                print("应用没有活动了，退到后台或者锁屏，基本和background一起被调用")
            case .background:
                print("应用不在显示前台")
            @unknown default:
                print("应用的其他情况")
            }
        }
    }
}


//MARK: - 创建Popup的配置内容
private extension youApp {
    func configurePopup(_ config: GlobalConfig) -> GlobalConfig { config
        ///以下配置的是顶部、中间、底部的操作行为
        .top { $0
            ///顶部圆角设置
            .cornerRadius(24)
            ///是否允许拖拽隐藏
            .dragGestureEnabled(true)
        }
        .centre { $0
            ///是否允许点击外部隐藏
            .tapOutsideToDismiss(false)
        }
        .bottom { $0
            .cornerRadius(10)
            .dragGestureEnabled(false)
            .tapOutsideToDismiss(true)
            .stackLimit(4)
        }
    }
}
