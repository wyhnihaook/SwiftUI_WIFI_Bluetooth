//
//  AccountOperationModel.swift
//  you
//  注册 + 忘记密码逻辑【核心是发起验证码和最终确定功能业务逻辑不同】
//  Created by 翁益亨 on 2024/7/22.
//

import Foundation
class AccountOperationModel : BaseModel{
    //登录的用户名称【可以接受手机号或者邮箱或者昵称】
    @Published var username : String = ""
    
    //获取验证码后的验证码信息同步
    @Published var verificationCode : String = ""

    
    //登录的密码
    @Published var password : String = ""
    //确认的登录密码
    @Published var confirmPassword : String = ""
    
    //标识是否注册/修改成功，成功后自动登录,默认：false，由接口返回用户信息后设置为true
    @Published var isLoginSuccess : Bool = false
    
    //当前是否高亮状态设置
    var isLight : Bool {
        get{
            return username.isNotEmpty && verificationCode.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty
        }
    }
    
    
    //校验2次密码一致性
    func verificationPassword() -> Bool{
        return confirmPassword == password
    }
    
    
    //MARK: - 注册
    func register(){
        if !verificationPassword(){
            return
        }
    }
    
    //MARK: - 忘记密码
    func forgetPassword(){
        if !verificationPassword(){
            return
        }
    }
    
}
