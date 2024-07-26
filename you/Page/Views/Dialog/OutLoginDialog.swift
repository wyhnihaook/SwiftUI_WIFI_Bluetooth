//
//  OutLoginDialog.swift
//  you
//  【退出登录弹窗】结合sheet展示
//  Created by 翁益亨 on 2024/7/26.
//

import SwiftUI
import LeanCloud

struct OutLoginDialog: View {
    
    @Binding var showDialog : Bool
    
    var callback : ()->Void
    
    init(showDialog: Binding<Bool>,callback:@escaping ()->Void){
        self._showDialog = showDialog
        self.callback = callback
    }
    
    var body: some View {
        VStack{
            Spacer()
            
            VStack(spacing:0){
                HStack{
                    Text("退出登录").foregroundColor(.black).bold()
                    Spacer()
                    Image("circle_delete").resizable().frame(width: 14,height: 14)
                }.frame(height: 40).frame(maxWidth: .infinity)
                
                Divider().background(Color(hexString: "#E9E9E9"))
                
                Spacer().frame(height: 20)
                
                Text("退出登录吗？\n请确认所有转写任务已完成")
                
                Spacer().frame(height: 30)
                
                HStack{
                    Button{
                        withAnimation {
                            showDialog.toggle()
                        }
                    }label: {
                        Text("取消").foregroundColor(.white).frame(maxWidth: .infinity).frame(height:40).background(.black).cornerRadius(10)
                    }
                    
                    Spacer().frame(width:20)
                    
                    Button{
                        //LeanCloud 退出登录
                        LCUser.logOut()
                        callback()
                    }label: {
                        Text("退出登录").foregroundColor(.black).frame(maxWidth: .infinity).frame(height:40).background(.yellow).cornerRadius(10)
                    }
                }
                
                Spacer().frame(height: 40)
                
            }.padding(.horizontal,15).background(.white).cornerRadius(10)
            
            
            
        }.edgesIgnoringSafeArea(.all)
            //背景颜色区域和上述位置设定区域两个都要设置才能撑满全屏
            .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all).onTapGesture(perform: {
            //点击收起回调
                withAnimation {
                    showDialog.toggle()
                }
            }))
    }
}
