//
//  ConnectBluetoothView.swift
//  you
//  连接蓝牙界面
//  Created by 翁益亨 on 2024/7/31.
//

import SwiftUI

struct ConnectBluetoothView: View {
    
    //蓝牙扫描是否超时
    @State var isTimeout : Bool = false
    @State private var animateCircle = false

    
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
                    ZStack {
                        Circle()
                            .stroke()
                            .frame(width:200,height: 200)
                            .foregroundColor(.blue)
                            .scaleEffect(animateCircle ? 1.0 : 0.3)
                            .opacity(animateCircle ? 0 : 1)
                        
                        Circle()
                            .stroke()
                            .frame(width:100,height: 100)
                            .foregroundColor(.blue)
                            .scaleEffect(animateCircle ? 1.0 : 0.3)
                            .opacity(animateCircle ? 0 : 1)
                        
                        Circle()
                            .stroke()
                            .frame(width:50,height: 50)
                            .foregroundColor(.blue)
                            .scaleEffect(animateCircle ? 1.0 : 0.3)
                            .opacity(animateCircle ? 0 : 1)
                    }.frame(width: 300,height: 300)

                  
                    
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
                    withAnimation(.easeIn(duration: 3).repeatForever(autoreverses: false)){
                        animateCircle.toggle()
                    }
                }

            
        }
    }
}

struct ConnectBluetoothView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectBluetoothView()
    }
}


