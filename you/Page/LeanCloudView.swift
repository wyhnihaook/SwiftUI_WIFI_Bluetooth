//
//  LeanCloudView.swift
//  you
//  LeanCloud功能测试
//  Created by 翁益亨 on 2024/7/19.
//

import SwiftUI
import LeanCloud

struct LeanCloudView: View {
    var body: some View {
        VStack(spacing:30){
            //运营商发送验证码功能暂未实现
            
            Button("手机验证码注册"){
                //注意手机号格式要以+和国家代码开头。例如： +86
                LCUser.signUpOrLogIn(mobilePhoneNumber: "+8618868944833", verificationCode: "123433"){
                    result in
                    switch result{
                    case .success(object: let user):
                        //["emailVerified": false, "mobilePhoneVerified": true, "__type": "Object", "updatedAt": ["iso": "2024-07-19T07:51:11.325Z", "__type": "Date"], "createdAt": ["iso": "2024-07-19T07:39:56.908Z", "__type": "Date"], "shortId": "srwwue", "objectId": "669a184c6407107da4bca6da", "className": "_User", "sessionToken": "c04zjc2lx7oumkdf57pbm5m9z", "username": "+8618868944833", "mobilePhoneNumber": "+8618868944833"]

                        print(user.jsonValue)
                    case .failure(error: let error):
                        //返回示例
                        //LCError(code: 603, reason: "无效的短信验证码")
                        print(error)
                    }
                }
            }
            
            Button("退出登录"){
                //退出登录后，SDK持久化存储信息被清除
                LCUser.logOut()
            }
            
            //添加数据结构同步到LeanCloud
            //单表数据
            Button("添加用户的昵称和性别"){
                //1.向UserInfo的表中插入数据。数据格式包括：name + gender
                let userInfo = LCObject(className: "UserInfo")
                do{
                    try userInfo.set("name", value: "ssh")
                    try userInfo.set("gender", value: 1)
                    try userInfo.set("age", value: 12)

                    //保存数据到云端数据库内容
                    userInfo.save{
                        result in
                        switch result{
                        case .success:
                            print("保存成功")
                        case .failure(error: let error):
                            print(error)
                        }
                    }

                }catch{
                    print(error)
                }
            }
            
        }.onAppear{
            //当前用户信息会缓存到SDK中，直接通过方法获取
            //【可用于欢迎页面的定向跳转】首页/登录页面
            if let user = LCApplication.default.currentUser{
                //存在的情况
                print(user.jsonValue)
            }else{
                //不存在的情况
                print("不存在登录的用户")
            }
        }
    }
}

struct LeanCloudView_Previews: PreviewProvider {
    static var previews: some View {
        LeanCloudView()
    }
}
