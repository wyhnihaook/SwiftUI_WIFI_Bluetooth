//
//  FastConnectPopup.swift
//  you
//  快速传输连接提示
//  Created by 翁益亨 on 2024/8/5.
//

import SwiftUI

struct FastConnectPopup : BottomPopup{
    func createContent() -> some View {
        VStack(spacing: 0){
            Text("快速传输").bold().modifier(PopupTitleStyle()).padding(.vertical, 20)

            Text("在快速传输过程中，您的手机将连接到PLAUD NOTE热点。为确保快速传输成功，当您看到以下弹出的窗口时，请：").bold().modifier(PopupContentStyle())
            

            Text("允许PLAUD加入WIFI网络").bold().modifier(PopupDescStyle()).padding(.vertical, 20)
            
            
            
            //GIF本地图片加载
            
            
            //连接不再提示功能
            HStack(spacing:0){
                Label{
                    Text("不再提示").font(.system(size: 12)).foregroundColor(.gray)
                }icon: {
                    Image("icon_rect_unselect").resizable().frame(width:22,height: 22)
                }.onTapGesture {
                    print("不再提示")
                }.padding(0)
                
                Spacer()
            }.padding(.vertical, 30)
            
            
            
            HStack(spacing:0){
                Button{
                    dismiss()
                }label: {
                    Text("取消").bold().foregroundColor(.black).frame(maxWidth: .infinity).frame(height: 40).background(Color.color_f6f7f9).cornerRadius(4)
                }
                
                Spacer.width(20)
                
                Button{
                    //开启热点连接。不再提示状态持久化记录，弹窗替换
                    //弹出连接状态的弹窗信息
                    FastConnectStatusPopup().showAndReplace()
                    
                }label: {
                    Text("开启").bold().foregroundColor(.blue).frame(maxWidth: .infinity).frame(height: 40).background(Color.color_d7e8f0).cornerRadius(4)
                }
            }

            
        }.padding(.horizontal, 15)
    }
}
