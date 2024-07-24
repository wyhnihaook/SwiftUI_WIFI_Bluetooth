//
//  LoginView.swift
//  you
//  登录页面，需要在页面生命周期初始化时进行判断跳转
//  【需要处理NavigationView】
//  Created by 翁益亨 on 2024/7/3.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var loginModel = LoginModel()
    
    var body: some View{
        //用于获取屏幕的尺寸
        GeometryReader{geometry in
            ZStack(alignment:.bottom){
                Rectangle().foregroundColor(.black).frame(maxWidth: .infinity,maxHeight: .infinity)
                
                //设置颜色遮盖底部颜色
                Rectangle().foregroundColor(.white)
                    .frame(maxWidth: .infinity,maxHeight: 100)
                
                VStack(spacing:0){
                    Spacer().frame(height: 30)
                    
                    
                    //直接设置border结合cornerRadius会出现border圆角适配不了的情况，所以要结合overlay实现
                    
                    //设置尺寸再设置圆角
                    TextField("邮箱地址",text:$loginModel.username,
                              prompt: Text("邮箱地址").font(.system(size: 16).bold()))
                    .frame(height: 50)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 40))
                    .background(Color(hexString: "#F6F7F9"))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                    .overlay(content: {
                        //创建一个视图容器显示在页面上
                        //视图尺寸遵循调用者的尺寸，简单理解为一个便捷的ZStack
                        RoundedRectangle(cornerRadius: 10).stroke(Color(hexString: "#E9E9E9")!, lineWidth: 1)
                        
                        if loginModel.username.isNotEmpty{
                            let imageInfo = ImageInfo(imageUrl: "circle_delete", width: 14, height: 14)
                            
                            RightImageWidget(imageInfo: imageInfo) {
                                loginModel.username = ""
                            }
                         
                        }
                    })
                    
                    Spacer().frame(height: 20)

                    //密码要结合显示隐藏功能处理
                    ZStack{
                        if !loginModel.hiddenPassword{
                            TextField("输入密码",text:$loginModel.password,
                                      prompt: Text("输入密码").font(.system(size: 16)).bold())
                        }else {
                            SecureField("输入密码",text:$loginModel.password,
                                      prompt: Text("输入密码").font(.system(size: 16)).bold())
                        }
                        
                    }
                    .frame(height: 50)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 80))
                    .background(Color(hexString: "#F6F7F9"))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                    .overlay(content: {
                        //创建一个视图容器显示在页面上
                        //视图尺寸遵循调用者的尺寸，简单理解为一个便捷的ZStack
                        RoundedRectangle(cornerRadius: 10).stroke(Color(hexString: "#E9E9E9")!, lineWidth: 1)
                        
                        if loginModel.password.isNotEmpty{
                            
                            let imageInfo = ImageInfo(imageUrl: loginModel.hiddenPassword ? "hidden_password" : "show_password", width: 28, height: 14)
                            
                            RightImageWidget(imageInfo: imageInfo) {
                                loginModel.hiddenPassword = !loginModel.hiddenPassword
                            }

                        }
                        
                    })
                      
                
                    Text(loginModel.errorDesc).font(.system(size: 12)).foregroundColor(.red)
                        .frame(maxWidth:.infinity,alignment:.leading)
                        .frame(height: 30)
                    
                    Spacer().frame(height: 30)
                    
                    //如果Button的尺寸由Text撑开，那么软键盘弹出时，高度会收缩到包裹Text内容的高度，所以最好直接设置Button的尺寸属性
                    //注意这里Button点击区域是Text尺寸决定的
                    
                    //使用注意：NavigationLink中的视图触摸的点击事件被迁移到自身了，和内部的Button无关，点击后直接触发跳转【和isActive无关，点击视为设置为true】
                    Group{
                        PushView(destination: OtherView(),isActive: $loginModel.isLoginSuccess){}
                        
                        Button{
    //                        点击登录
                            loginModel.login()
                        }label: {
                            Text("登录").foregroundColor(.white)
                                .font(.system(size: 18)).bold()
                                .frame(maxWidth: .infinity,alignment: .center)
                        }
                            .frame(maxWidth: .infinity,alignment: .center)
                            .padding(.vertical,15)
                            .background(loginModel.isLight ? .blue : .gray)
                            .cornerRadius(10)
                            //数据没有填写完毕之前不允许点击
                            .disabled(!loginModel.isLight)
                    }
                    
                    Spacer().frame(height: 20)

                    
                    HStack{
                        PushView(destination: AccountOperationView(type:0)) {
                            Text("立即注册").foregroundColor(.gray)
                                .font(.system(size: 12))
                        }
                        
                        Rectangle().frame(width: 1,height: 15).foregroundColor(.gray)
                        
                        PushView(destination: AccountOperationView(type: 1)) {
                            Text("忘记密码").foregroundColor(.gray)
                                .font(.system(size: 12))
                        }
                    }


                    Group{
                        Spacer()
                        
                        HStack(spacing:0){
                            Text("继续操作即表示您已阅读并同意《")
                            Text("用户协议").foregroundColor(.blue)
                            Text("》和《")
                            Text("隐私政策").foregroundColor(.blue)
                            Text("》。")
                        }.font(.system(size: 11))
                            .padding(0)
                        
                        
                        Spacer().frame(height: 40)
                    }
                    
                }.padding(.horizontal,30).background(.white)
                //默认不支持设置单个方向上的圆角
                .cornerRadius(20)
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height*3/4)
                
            }
        }.navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
