//
//  UserInfoView.swift
//  you
//  用户基本信息页面【账号和资料】
//  Created by 翁益亨 on 2024/7/2.
//

import SwiftUI

struct UserInfoView: View {
   
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        //外部NavigationLink跳转到一个新的导航器，内容全部自定义
        NavigationView {
            HStack{
             Text("11122")
            }
        }
        //默认的标题展示样式
//        .navigationBarTitle("账号和资料",displayMode:.inline)
        .navigationBarBackButtonHidden()
        .toolbar{
            //左侧按钮功能
            ToolbarItem(placement: .navigationBarLeading) {
                //显示的返回按钮信息
                Button{
                    presentationMode.wrappedValue.dismiss()
                }label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("账号和资料").foregroundColor(.black).font(.system(size: 18))
            }
            
            //右侧按钮功能
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("右侧按钮").font(.system(size: 14)).foregroundColor(.black)
            }
        }
        
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}
