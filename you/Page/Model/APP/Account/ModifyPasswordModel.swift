//
//  ModifyPasswordModel.swift
//  you
//
//  Created by 翁益亨 on 2024/7/26.
//

import SwiftUI
import LeanCloud

class ModifyPasswordModel : BaseModel{
    //当前密码
    @Published var currentPassword : String = ""
    //新密码
    @Published var newPassword : String = ""
    //确认密码
    @Published var confirmPassword : String = ""
    
    
    //显示密码控制，默认隐藏密码的显示
    @Published var hiddenCurrentPassword : Bool = true
    @Published var hiddenPassword : Bool = true
    @Published var hiddenConfirmPassword : Bool = true
    
    //重新登录标识
    @Published var isToLogin : Bool = false
    
    //错误提示展示
    @Published var errorDesc : String = ""
    
    var isLight : Bool {
        get{
            return currentPassword.isNotEmpty && newPassword.isNotEmpty && confirmPassword.isNotEmpty
        }
    }
    
    
    func modifyPassword(){
        //首先判断两个重置密码是否相同
        
        if newPassword != confirmPassword{
            self.errorDesc = "两次密码不一致"
            return
        }
        
        if let user = LCApplication.default.currentUser {
            //【LeanCloud】的邮箱密码必须要通过邮箱来修改，暂不支持密码修改
            if self.currentPassword != (user.password?.value ?? ""){
                self.errorDesc = "当前密码错误，请重新输入"
                return
            }
            
            user.save { (result) in
                switch result {
                case .success:
                    //跳转到重新登录页面
                    self.isToLogin.toggle()
                case .failure(error: let error):
                    print(error)
                }
            }
        } else {
            // 显示注册或登录页面
        }
        
    }
}
