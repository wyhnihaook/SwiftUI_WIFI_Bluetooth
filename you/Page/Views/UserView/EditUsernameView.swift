//
//  EditUsernameView.swift
//  you
//  修改用户昵称功能
//  Created by 翁益亨 on 2024/7/25.
//

import SwiftUI

struct EditUsernameView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @StateObject var editModel = EditModel()

    //默认输入聚焦状态
    @FocusState var isFocused : Bool
    
    //默认填充的昵称
    var username : String
    
    //保存完毕之后回调【用于显示toast】
    var callback : ()->Void
    
    init(username : String , callback:@escaping ()->Void){
        self.username = username
        self.callback = callback
    }
    
    var body: some View {
        NavigationBody(title: "昵称") {
            Text("保存").foregroundColor(editModel.modifyUsername.isEmpty ? .gray : .blue).onTapGesture {
                editModel.updateUsername{                    
                    callback()
                    self.presentationMode.wrappedValue.dismiss()
                }
            }.disabled(editModel.modifyUsername.isEmpty)
        } content: {
            VStack{
                Spacer().frame(height: 20)
                //输入框默认聚焦
                
                TextField("昵称",text:$editModel.modifyUsername,
                          prompt: Text(username).font(.system(size: 16).bold()))
                .focused($isFocused)
                .frame(height: 50)
                .padding(.horizontal, 15)
                .background(.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                
                Spacer()
            }.padding(.horizontal,15)
            .background(Color(hexString: "#F4F6F7"))
        }.onAppear{
            //显示后自动聚焦输入内容，注意⚠️：需要延时处理才会弹出，测试手机最短响应时间0.5s
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                isFocused = true
            }
        }

    }
}

struct EditUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        EditUsernameView(username: ""){}
    }
}
