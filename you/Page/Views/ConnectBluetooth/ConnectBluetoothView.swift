//
//  ConnectBluetoothView.swift
//  you
//  连接蓝牙界面
//  Created by 翁益亨 on 2024/7/31.
//

import SwiftUI

struct ConnectBluetoothView: View {
    
    //扩散水波纹数据记录
    @State private var beatAnimation: Bool = false
    @State private var showPulses: Bool = false
    @State private var pulsedHearts: [HeartParticle] = []
    
    //蓝牙扫描是否超时
    @State var isTimeout : Bool = false

    
    var body: some View {
        NavigationBody(title: "连接蓝牙") {
            Image(systemName: "house")
        } content: {
            VStack(spacing:0){
                Spacer().frame(height: 40)
                
                if !isTimeout{
                    Text("正在搜索附近的蓝牙设备...").foregroundColor(.black).font(.system(size: 14))
                    Spacer().frame(height: 30)
                    Text("让蓝牙设备距离手机更近一点。").foregroundColor(.gray).font(.system(size: 14))
                    Spacer().frame(height: 80)
                    
                    ///动画效果展示波纹
                    ZStack{
                        ///根据设定的时间间隔不停的进行内容的调度
                        if showPulses {
                            TimelineView(.animation(minimumInterval: 0.7, paused: false)) {  timeLine in
                                addView(timeLine.date)
                            }
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
                
                
            }.padding(.horizontal,20)
                .onAppear{
                    ///开启动画标识
                    beatAnimation.toggle()
                    ///页面控制标识
                    showPulses.toggle()
                    ///添加内容标识
                    addPulsedHeart()
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

struct ConnectBluetoothView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectBluetoothView()
    }
}


