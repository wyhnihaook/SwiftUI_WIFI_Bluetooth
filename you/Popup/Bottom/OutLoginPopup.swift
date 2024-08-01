//
//  OutLoginPopup.swift
//  you
//  退出登录弹窗
//  Created by 翁益亨 on 2024/8/1.
//

import Foundation
import SwiftUI

struct OutLoginPopup : BottomPopup{
    
    private var callback:()->Void
    
    init(callback:@escaping ()->Void){
        self.callback = callback
    }
    
    //展示的内容
    func createContent() -> some View {
        VStack(spacing:0){
            createTitle()
            Spacer.height(10)
            Divider().background(Color(hexString: "#E9E9E9"))
            Spacer.height(20)
            
            createDesc()
            
            Spacer.height(30)
            
            createOperate(callback: callback)
        }.padding(.top, 12)
        .padding(.bottom, 4)
        .padding(.horizontal, 28)
    }
}

private extension OutLoginPopup {
    func createTitle() -> some View {
        HStack{
            Text("退出登录").foregroundColor(.black).bold()
            Spacer()
            Image("circle_delete").resizable().frame(width: 14,height: 14)
        }.frame(height: 40).frame(maxWidth: .infinity)
    }
    
    func createDesc() -> some View{
        Text("退出登录吗？\n请确认所有转写任务已完成")
    }
    
    func createOperate(callback:@escaping ()->Void) -> some View{
        HStack{
            Button{
               dismiss()
            }label: {
                Text("取消").foregroundColor(.white).frame(maxWidth: .infinity).frame(height:40).background(.black).cornerRadius(10)
            }
            
            Spacer.width(20)
            
            Button{
                callback()
                dismiss()
            }label: {
                Text("退出登录").foregroundColor(.black).frame(maxWidth: .infinity).frame(height:40).background(.yellow).cornerRadius(10)
            }
        }
    }
    
}
