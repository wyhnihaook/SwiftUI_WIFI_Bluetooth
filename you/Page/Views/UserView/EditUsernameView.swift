//
//  EditUsernameView.swift
//  you
//  修改用户昵称功能
//  Created by 翁益亨 on 2024/7/25.
//

import SwiftUI

struct EditUsernameView: View {
    
    @StateObject var editModel = EditModel()
    
    @State var username : String
    
    init(username : String){
        self.username = username
    }
    
    var body: some View {
        NavigationBody(title: "昵称") {
            Text("保存").onTapGesture {
                
            }
        } content: {
            VStack{
                Spacer().frame(height: 20)
                //输入框默认聚焦
                TextField("昵称",text:$username,
                          prompt: Text("昵称").font(.system(size: 16).bold()))
                .frame(height: 50)
                .padding(.horizontal, 15)
                .background(.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                
                Spacer()
            }.padding(.horizontal,15)
            .background(Color(hexString: "#F4F6F7"))
        }

    }
}

struct EditUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        EditUsernameView(username: "")
    }
}
