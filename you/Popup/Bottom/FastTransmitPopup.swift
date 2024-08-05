//
//  FastTransmitPopup.swift
//  you
//  快速传输 提示
//  Created by 翁益亨 on 2024/8/5.
//

import SwiftUI

struct FastTransmitPopup : BottomPopup{
    func createContent() -> some View {
        VStack(spacing:0){
            Spacer.height(20)
            Text("快速传输").bold().modifier(PopupTitleStyle())
            Spacer.height(20)

            Text("快速传输将使传输速度提高约10倍").bold().modifier(PopupDescStyle())
            Spacer.height(10)

            Text("在传输期间，您的手机将连接到PLAUD NOTE热点。如果您的手机正在连接另一个WIFI网络，它将暂时断开链接，在传输完成之后重新连接").bold().modifier(PopupContentStyle())
            Spacer.height(30)

            HStack(spacing:0){
                Button{
                    dismiss()
                }label: {
                    Text("取消").bold().foregroundColor(.black).frame(maxWidth: .infinity).frame(height: 40).background(Color.color_f6f7f9).cornerRadius(4)
                }
                
                Spacer.width(20)
                
                Button{
                    //开启热点连接，这里要判断当前是否需要提示连接前置提示。如果需要提示就展示连接提醒。否则直接连接
                    //弹出连接状态的弹窗信息，直接替换当前的弹窗显示
                    
                    FastConnectPopup().showAndReplace()
                    
                    
                }label: {
                    Text("开启").bold().foregroundColor(.blue).frame(maxWidth: .infinity).frame(height: 40).background(Color.color_d7e8f0).cornerRadius(4)
                }
            }
            
        }.padding(.horizontal, 15)
    }
}



