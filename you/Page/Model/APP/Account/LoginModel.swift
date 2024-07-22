//
//  LoginModel.swift
//  you
//  登录页面数据处理
//  Created by 翁益亨 on 2024/7/22.
//

import Foundation
import SwiftUI
import LeanCloud

class LoginModel : BaseModel{
    //登录的用户名称【可以接受手机号或者邮箱或者昵称】
    @Published var username : String = ""
    
    //登录的密码【可以为手机验证码或者是设置的密码】
    @Published var password : String = ""

    //登录类型来匹配【0:验证码登录】
    @Published var type : Int = 0
    
    //标识是否登录成功,默认：false，由接口返回用户信息后设置为true
    @Published var isLoginSuccess : Bool = false
    
    //当前是否高亮状态设置
    var isLight : Bool {
        get{
            return username.isNotEmpty && password.isNotEmpty
        }
    }
    
    
    //MARK: -LeanCloud 登录操作，这里使用手机号验证码登录
    func login(){
        LCUser.logIn(mobilePhoneNumber: username, verificationCode: password){
            result in
            switch result{
            case .success(object: let user):
                //["emailVerified": false, "mobilePhoneVerified": true, "__type": "Object", "updatedAt": ["iso": "2024-07-19T07:51:11.325Z", "__type": "Date"], "createdAt": ["iso": "2024-07-19T07:39:56.908Z", "__type": "Date"], "shortId": "srwwue", "objectId": "669a184c6407107da4bca6da", "className": "_User", "sessionToken": "c04zjc2lx7oumkdf57pbm5m9z", "username": "+8618868944833", "mobilePhoneNumber": "+8618868944833"]

                self.isLoginSuccess = true
                print(user.jsonValue)
            case .failure(error: let error):
                //返回示例
                //LCError(code: 603, reason: "无效的短信验证码")
                print(error)
            }
        }
    }
    
}
