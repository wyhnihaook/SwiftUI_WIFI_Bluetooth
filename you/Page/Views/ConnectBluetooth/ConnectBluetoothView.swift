//
//  ConnectBluetoothView.swift
//  you
//  连接蓝牙界面【由于外设同步的信息在多个页面都可以查询，所以要放到公共的全局环境中】
//  Created by 翁益亨 on 2024/7/31.
//

import SwiftUI
import Bluejay

struct ConnectBluetoothView: View {
    let maxScanCount = 9
    
    //扩散水波纹数据记录
    @State private var beatAnimation: Bool = false
    @State private var showPulses: Bool = false
    @State private var pulsedHearts: [HeartParticle] = []
    
    //蓝牙扫描是否超时 当前扫描超时次数，超过限定扫描次数就显示超时
    @State var scanCount : Int = 0

    //共享的数据获取【内含蓝牙管理内容】
    @EnvironmentObject var sharedData : SharedData
    
    var body: some View {
        NavigationBody(title: "连接蓝牙") {
            Image(systemName: "house")
        } content: {
            VStack(spacing:0){
                Spacer().frame(height: 40)
                
                if sharedData.selectedSensor != nil || sharedData.sensors.count > 0{
                    //展示检索设备结果
                    if sharedData.selectedSensor != nil && sharedData.sensors.count == 0{
                        //说明是之前连接的信息展示
                        HStack{
                            Text(sharedData.selectedSensor!.name)
                            Spacer()
                            
                            Text("已连接").font(.system(size: 12))
                                .foregroundColor(.red)
                            
                        }.padding(.vertical, 5).padding(.horizontal, 15).frame(height:40).background(.white).cornerRadius(4)
                    }else{
                        ForEach(sharedData.sensors,id: \.self.peripheralIdentifier.uuid) { sensor in
                            
                            //展示所有检索到的外设信息
                            HStack{
                                Text(sensor.peripheralIdentifier.name)
                                Spacer()
                                
                                if sharedData.connceted{
                                    Text(sensor.peripheralIdentifier.uuid == sharedData.selectedSensor?.uuid ? "已连接":"").font(.system(size: 12))
                                        .foregroundColor(.red)
                                }
                                
                            }.padding(.vertical, 5).padding(.horizontal, 15).frame(height:40).background(.white).cornerRadius(4).onTapGesture {
                                //点击链接蓝牙功能.这里可能连接失败，需要根据回调提示用户信息
                                sharedData.connectBluetooth(device: sensor)
                            }
                        }
                    }
                    
                    
                    Spacer()
                }else if showPulses{
                    Text("正在搜索附近的蓝牙设备...").foregroundColor(.black).font(.system(size: 14))
                    Spacer().frame(height: 30)
                    Text("让蓝牙设备距离手机更近一点。").foregroundColor(.gray).font(.system(size: 14))
                    Spacer().frame(height: 80)
                    
                    ///动画效果展示波纹
                    ZStack{
                        ///根据设定的时间间隔不停的进行内容的调度
                        TimelineView(.animation(minimumInterval: 0.7, paused: false)) {  timeLine in
                            addView(timeLine.date)
                        }
                       
                        
                        ///可以进行额外内容绘制
//                        Image(systemName: "suit.heart.fill")
//                            .font(.system(size: 100))
//                            .foregroundStyle(.red.gradient)
                  
                        
                    } .frame(maxWidth: 350, maxHeight: 350)

                  Spacer()
                    
                }else{
                    Text("附近未搜索到蓝牙设备").foregroundColor(.black).font(.system(size: 14))
                    Spacer().frame(height: 30)
                    
                    ///gif图片
                    
                    Text("·请短按录音键唤醒蓝牙").foregroundColor(.gray).font(.system(size: 14))
                    Text("·白色指示灯亮起，表明蓝牙设备已经准备好连接。").foregroundColor(.gray).font(.system(size: 14))

                    Spacer()
                    
                    Label{
                        Text("仍然没有搜索到您的蓝牙？").foregroundColor(.blue).font(.system(size: 14))
                    }icon: {
                        Image(systemName: "house")
                    }
                    

                    Spacer().frame(height: 20)


                }
                
                
            }.onChange(of: sharedData.selectedSensor, perform: { newValue in
                //连接成功
                beatAnimation = false
                ///页面控制标识
                showPulses = false
                
            }).onChange(of: sharedData.sensors.count, perform: { newValue in
                if newValue > 0{
                    scanCount = 0
                    beatAnimation = false
                    showPulses = false
                }
            }).padding(.horizontal,20).background(Color.color_f6f7f9)
                .onAppear{

                    //视图初始化创建[BluetoothScanHelper]遵守协议的帮助类，用于验证蓝牙是否可用并开启扫描等业务
                    //开始扫描，列表展示设备内容。通过点击方法进行连接
                    sharedData.scanHeartSensors()
//                    sharedData.bluejay.register(connectionObserver: sharedData)
                    //判断当前蓝牙是否已经连接上，如果已经连接上就不展示内容。只有初始化才进行显示
                    //这里已经连接上就显示当前的内容
                    //展示对应的连接设备状态
                    ///开启动画标识
                    beatAnimation.toggle()
                    ///页面控制标识
                    showPulses.toggle()
                    ///添加内容标识
                    addPulsedHeart()
                    

                }.onDisappear{
                    //视图销毁
//                    sharedData.bluejay.unregister(connectionObserver: sharedData)
                    //页面关闭后，停止扫描功能
                    sharedData.bluejay.stopScanning()
                }

            
        }
    }
    
    //MARK: - 模拟心跳波纹扩散
    
    struct HeartParticle: Identifiable {
        var id: UUID = .init()
    }
     
    func addPulsedHeart() {
        let pulsedHeart = HeartParticle()
        pulsedHearts.append(pulsedHeart)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            pulsedHearts.removeAll(where: { $0.id == pulsedHeart.id })
            if pulsedHearts.isEmpty {
                showPulses = false
            }
        }
    }
    
    @ViewBuilder
    func addView(_ date: Date) -> some View {
        ZStack {
            ForEach(pulsedHearts) { heart in
                PulseHeartView()
            }
        }.onChange(of: date) { newValue in
                //超时标识
                scanCount += 1
                if scanCount >= maxScanCount{
                    //停止水波纹扩散，重置内容
                    scanCount = 0
                    beatAnimation.toggle()
                    showPulses.toggle()
                    return
                }
            
            
                if beatAnimation {
                    addPulsedHeart()
                }
            }

    }
    
    struct PulseHeartView: View {
        @State private var startAnimation: Bool = false
        
        var body: some View {
            
            //波纹扩散
            Circle()
                   .stroke()
                   .frame(width: 10, height: 10)
                   .foregroundColor(.blue)
                    ///等比例缩放当前的最大尺寸
                   .scaleEffect(startAnimation ? 30 : 1)
                   .opacity(startAnimation ? 0 : 1)
                   .onAppear(perform: {
                       withAnimation(.linear(duration: 3)) {
                            startAnimation = true
                       }
                   })
            
//            Image(systemName: "suit.heart.fill")
//                .font(.system(size: 100))
//                .foregroundStyle(.red.gradient)
//                .background() {
//                    Image(systemName: "suit.heart.fill")
//                        .font(.system(size: 100))
//                        .foregroundStyle(.black.gradient)
//                        .blur(radius: 5, opaque: false)
//                        .scaleEffect(startAnimation ? 1.1 : 0)
//                        .animation(.linear(duration: 1.5), value: startAnimation)
//                }
//                .scaleEffect(startAnimation ? 4 : 1)
//                .opacity(startAnimation ? 0 : 1)
//                .onAppear(perform: {
//                    withAnimation(.linear(duration: 3)) {
//                         startAnimation = true
//                    }
//                })
        }
    }
    
    
}

//struct ConnectBluetoothView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConnectBluetoothView()
//    }
//}


