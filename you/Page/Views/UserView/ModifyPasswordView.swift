//
//  ModifyPasswordView.swift
//  you
//  修改密码功能
//  Created by 翁益亨 on 2024/7/26.
//

import SwiftUI

struct ModifyPasswordView: View {
    
    @StateObject var model = ModifyPasswordModel()
    
    
    var body: some View {
        NavigationBody(title: "更改密码") {
            
        } content: {
            VStack(alignment:.leading){
                //输入功能
                Spacer().frame(height: 20)
                
                VStack{
                    
                    ZStack{
                        if !model.hiddenCurrentPassword{
                            TextField("当前密码",text:$model.currentPassword,
                                      prompt: Text("当前密码").font(.system(size: 16)))
                        }else {
                            SecureField("当前密码",text:$model.currentPassword,
                                      prompt: Text("当前密码").font(.system(size: 16)))
                        }
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 80))        .overlay(content: {
                        //创建一个视图容器显示在页面上
                        //视图尺寸遵循调用者的尺寸，简单理解为一个便捷的ZStack
                        
                        if model.currentPassword.isNotEmpty{
                            
                            let imageInfo = ImageInfo(imageUrl: model.hiddenCurrentPassword ? "hidden_password" : "show_password", width: 28, height: 14)
                            
                            RightImageWidget(imageInfo: imageInfo) {
                                model.hiddenCurrentPassword.toggle()
                            }

                        }
                        
                    })
                    
                    ZStack{
                        if !model.hiddenPassword{
                            TextField("新密码",text:$model.newPassword,
                                      prompt: Text("新密码").font(.system(size: 16)))
                        }else {
                            SecureField("新密码",text:$model.newPassword,
                                      prompt: Text("新密码").font(.system(size: 16)))
                        }
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 80))        .overlay(content: {
                        //创建一个视图容器显示在页面上
                        //视图尺寸遵循调用者的尺寸，简单理解为一个便捷的ZStack
                        
                        if model.newPassword.isNotEmpty{
                            
                            let imageInfo = ImageInfo(imageUrl: model.hiddenPassword ? "hidden_password" : "show_password", width: 28, height: 14)
                            
                            RightImageWidget(imageInfo: imageInfo) {
                                model.hiddenPassword.toggle()
                            }

                        }
                        
                    })
                    
                    
                    ZStack{
                        if !model.hiddenConfirmPassword{
                            TextField("确认密码",text:$model.confirmPassword,
                                      prompt: Text("确认密码").font(.system(size: 16)))
                        }else {
                            SecureField("确认密码",text:$model.confirmPassword,
                                      prompt: Text("确认密码").font(.system(size: 16)))
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
                                model.hiddenConfirmPassword.toggle()
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
                    NavigationLink(destination: LoginView(), isActive:$model.isToLogin){}
                    
                    Button{
                        model.modifyPassword()
                    }label: {
                        Text("保存").foregroundColor(.white)
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

struct ModifyPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyPasswordView()
    }
}
