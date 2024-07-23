//
//  AccountOperationView.swift
//  you
//  账号操作【包括：注册、修改密码】
//  Created by 翁益亨 on 2024/7/22.
//

import SwiftUI

struct AccountOperationView: View {
    @StateObject var model = AccountOperationModel()
    
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
                    TextField("邮箱地址",text:$model.username,
                              prompt: Text("邮箱地址").font(.system(size: 16).bold()))
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 40))
                    .overlay {
                        if model.username.isNotEmpty{
                            let imageInfo = ImageInfo(imageUrl: "circle_delete", width: 14, height: 14)
                            
                            RightImageWidget(imageInfo: imageInfo) {
                                model.username = ""
                            }
                        }
                    }
                    
//                    TextField("验证码",text:$model.verificationCode,
//                              prompt: Text("验证码").font(.system(size: 16).bold()))
//                    .frame(height: 50)
//                    .frame(maxWidth: .infinity)
//                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 150))
//                    .overlay {
//                        HStack{
//                            Spacer()
//
//                            Button{
//                                //点击倒计时处理
//                                model.getVerificationCode {
//                                    //发送完成之后才会进行倒计时处理
//                                    if !model.isCountingDown{
//                                        model.startCountdown()
//                                    }
//                                }
//
//                            }label: {
//                                Text(model.isCountingDown ? "重发(\(model.countdown)s）" : "获取验证码").font(.system(size:13)).foregroundColor(.white).frame(width: 100,height: 30)
//                                    .background(model.isCountingDown || model.lockVerificationCode ? .gray : .black).cornerRadius(15)
//                            }
//                            //在倒计时或者锁定中无法点击
//                            .disabled(model.isCountingDown || model.lockVerificationCode)
//                                .onReceive(model.countdownTimer) { _ in
//                                    if model.isCountingDown{
//                                        if model.countdown > 0{
//                                            model.countdown -= 1
//                                        }else{
//                                            model.stopCountdown()
//                                        }
//                                    }
//                                }
//
//                            Spacer().frame(width: 15)
//                        }
//                    }
                    
                    
                    ZStack{
                        if !model.hiddenPassword{
                            TextField("密码",text:$model.password,
                                      prompt: Text("密码").font(.system(size: 16).bold()))
                        }else {
                            SecureField("密码",text:$model.password,
                                      prompt: Text("密码").font(.system(size: 16)).bold())
                        }
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 80))        .overlay(content: {
                        //创建一个视图容器显示在页面上
                        //视图尺寸遵循调用者的尺寸，简单理解为一个便捷的ZStack
                        
                        if model.password.isNotEmpty{
                            
                            let imageInfo = ImageInfo(imageUrl: model.hiddenPassword ? "hidden_password" : "show_password", width: 28, height: 14)
                            
                            RightImageWidget(imageInfo: imageInfo) {
                                model.hiddenPassword = !model.hiddenPassword
                            }

                        }
                        
                    })
                    
                    
                    ZStack{
                        if !model.hiddenConfirmPassword{
                            TextField("确认密码",text:$model.confirmPassword,
                                      prompt: Text("确认密码").font(.system(size: 16).bold()))
                        }else {
                            SecureField("确认密码",text:$model.confirmPassword,
                                      prompt: Text("确认密码").font(.system(size: 16)).bold())
                        }
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 80))
                    .overlay(content: {
                        //创建一个视图容器显示在页面上
                        //视图尺寸遵循调用者的尺寸，简单理解为一个便捷的ZStack
                        
                        if model.confirmPassword.isNotEmpty{
                            
                            let imageInfo = ImageInfo(imageUrl: model.hiddenConfirmPassword ? "hidden_password" : "show_password", width: 28, height: 14)
                            
                            RightImageWidget(imageInfo: imageInfo) {
                                model.hiddenConfirmPassword = !model.hiddenConfirmPassword
                            }

                        }
                        
                    })
                    
                }.background(.white)
                .cornerRadius(10)
                
                Text(model.errorDesc).font(.system(size: 12)).foregroundColor(.red)
                    .frame(maxWidth:.infinity,alignment:.leading)
                    .frame(height: 30)
                
                Spacer().frame(height: 50)
                
                //确认按钮
                Group{
                    NavigationLink(destination: OtherView(),isActive: $model.isLoginSuccess) {}
                    
                    Button{
                        if type == 0{
                            model.register{
                                
                            }
                        }else if type == 1{
                            model.forgetPassword()
                        }
                    }label: {
                        Text("确定").foregroundColor(.white)
                            .font(.system(size: 18)).bold()
                            .frame(maxWidth: .infinity,alignment: .center)
                    }
                        .frame(maxWidth: .infinity,alignment: .center)
                        .padding(.vertical,15)
                        .background(model.isLight ? .blue : .gray)
                        .cornerRadius(10)
                        //数据没有填写完毕之前不允许点击
                        .disabled(!model.isLight)
                    
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
