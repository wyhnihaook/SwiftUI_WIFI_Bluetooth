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

@main
struct youApp: App {
    //共享数据创建
    let sharedData = SharedData()
  
    init(){
        //这里执行全局内容信息，标识APP已经初始化
        //等同于 didFinishLaunchingWithOptions
        do {
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
    
    //14.0版本：可跟踪应用程序的状态：ScenePhase。配合WindowGroup使用【整个应用】
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
//            ContentView()
              OtherView()
//            LoginView()
//            MindMapView()
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

