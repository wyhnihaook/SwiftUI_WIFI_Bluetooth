//
//  AccountOperationModel.swift
//  you
//  注册 + 忘记密码逻辑【核心是发起验证码和最终确定功能业务逻辑不同】
//  Created by 翁益亨 on 2024/7/22.
//

import Foundation
import LeanCloud

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
    @Published var isRegisterSuccess : Bool = false
    @Published var isForgetSuccess : Bool = false

    //显示密码控制，默认隐藏密码的显示
    @Published var hiddenPassword : Bool = true
    @Published var hiddenConfirmPassword : Bool = true
    
    //错误提示展示
    @Published var errorDesc : String = ""
    
    //倒计时功能实现
    @Published var countdown : Int = 0
    @Published var isCountingDown : Bool = false
    let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    //锁定发送按钮
    @Published var lockVerificationCode : Bool = false

    //当前是否高亮状态设置
    var isRegisterLight : Bool {
        get{
            return username.isNotEmpty && verificationCode.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty
        }
    }
    
    
    var isForgetLight : Bool {
        get{
            return username.isNotEmpty
        }
    }
    
    //校验2次密码一致性
    func verificationPassword() -> Bool{
        return confirmPassword == password
    }
    
    
    //MARK: - 开始倒计时
    func startCountdown(){
        self.countdown = 10
        self.isCountingDown = true
    }
    
    //MARK: - 停止倒计时
    func stopCountdown(){
        self.isCountingDown = false
    }
    
    //MARK: - 注册。注册完毕之后跳转到中间页面提示用户去对应邮箱激活【使用邮箱激活账号到原因是因为手机号发送验证码需要开发者去配置，而邮箱激活是LeanCloud支持的功能】
    func register(sendCallBack:@escaping ()->Void){
        if !validateEmail(self.username){
            self.errorDesc = "邮箱格式错误"
            return
        }
        
        if !verificationPassword(){
            self.errorDesc = "两次密码不一致"
            return
        }
                
        //LeanCloud发送验证码成功后回调
        do {
            // 创建实例。设置默认的密码，在确定的时候来进行修改
            let user = LCUser()

            user.username = LCString(self.username)
            user.password = LCString(self.password)

            // 可选
            user.email = LCString(self.username)
//            user.emailVerified 在用户点击邮箱验证之后生效。登录情况依照这个
//            user.mobilePhoneNumber = LCString("+8619201680101")

            // 设置其他属性的方法跟 LCObject 一样，添加头像属性
            try user.set("headerImage", value: "")


            //注册用户信息
            _ = user.signUp { (result) in
                switch result {
                case .success:
                    //虚拟用户建立完成，通过邮箱验证进行邮箱有效性检查
                    LCUser.requestVerificationMail(email: self.username) { result in
                        switch result {
                        case .success:
                            sendCallBack()
                        case .failure(error: let error):
                            self.errorDesc = error.reason ?? ""
                        }
                    }
                case .failure(error: let error):
                    self.errorDesc = error.reason ?? ""
                }
            }
        } catch {
            print(error)
        }
        
        
    }
    
    //MARK: - 忘记密码【让用户在邮箱中的邮件进行操作修改密码】
    func forgetPassword(){
        if !validateEmail(self.username){
            self.errorDesc = "邮箱格式错误"
            return
        }
        ///发送邮件成功就跳转页面
        LCUser.requestPasswordReset(email: self.username) { (result) in
            switch result {
            case .success:
                self.isForgetSuccess.toggle()
            case .failure(error: let error):
                self.errorDesc = error.reason ?? ""
            }
        }
    }
    
    //MARK: - 获取验证码【邮箱注册是通过邮箱链接点击验证实现。LeanCloud目前只提供了一个手机号注册的功能】
    func getVerificationCode(sendCallBack:@escaping ()->Void){
        if !validateEmail(self.username){
            self.errorDesc = "邮箱格式错误"
            return
        }
        
        //LeanCloud不支持邮箱验证码，只支持手机验证码
        
    }
    
}
