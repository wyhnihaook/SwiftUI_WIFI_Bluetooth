//
//  AccountOperationView.swift
//  you
//  账号操作【包括：注册、修改密码】
//  Created by 翁益亨 on 2024/7/22.
//

import SwiftUI

struct AccountOperationView: View {
    @StateObject var accountOperationModel = AccountOperationModel()
    
    //初始化页面功能类型，默认是0/注册 1/修改密码
    private var type : Int = 0
    
    init(type: Int) {
        self.type = type
    }
    
    var body: some View {
        NavigationBody(title: type == 0 ? "注册" : "忘记密码"){
            //右侧的额外功能
        }content: {
            VStack(alignment:.leading){
                //输入功能
                Spacer().frame(height: 20)
                
                VStack{
                    TextField("用户名",text:$accountOperationModel.username,
                              prompt: Text("用户名").font(.system(size: 16).bold()))
                    .frame(height: 50)
                    .padding(.horizontal,15)
                    
                    TextField("验证码",text:$accountOperationModel.verificationCode,
                              prompt: Text("验证码").font(.system(size: 16).bold()))
                    .frame(height: 50)
                    .padding(.horizontal,15)
                    
                    TextField("密码",text:$accountOperationModel.password,
                              prompt: Text("密码").font(.system(size: 16).bold()))
                    .frame(height: 50)
                    .padding(.horizontal,15)
                    
                    TextField("确认密码",text:$accountOperationModel.confirmPassword,
                              prompt: Text("确认密码").font(.system(size: 16).bold()))
                    .frame(height: 50)
                    .padding(.horizontal,15)
                }.background(.white)
                .cornerRadius(10)
                
                Spacer().frame(height: 80)
                
                //确认按钮
                Group{
                    NavigationLink(destination: OtherView(),isActive: $accountOperationModel.isLoginSuccess) {}
                    
                    Button{
                        if type == 0{
                            accountOperationModel.register()
                        }else if type == 1{
                            accountOperationModel.forgetPassword()
                        }
                    }label: {
                        Text("确定").foregroundColor(.white)
                            .font(.system(size: 18)).bold()
                            .frame(maxWidth: .infinity,alignment: .center)
                    }
                        .frame(maxWidth: .infinity,alignment: .center)
                        .padding(.vertical,15)
                        .background(accountOperationModel.isLight ? .blue : .gray)
                        .cornerRadius(10)
                        //数据没有填写完毕之前不允许点击
                        .disabled(!accountOperationModel.isLight)
                    
                }
                
                Spacer()
            }.padding(.horizontal, 15)
            .background(Color(hexString: "#F6F7F9"))
        }
    }
}

struct AccountOperationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountOperationView(type: 0)
    }
}
