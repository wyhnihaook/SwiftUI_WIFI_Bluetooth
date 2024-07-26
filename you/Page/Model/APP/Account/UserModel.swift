//
//  UserModel.swift
//  you
//  关联【UserInfoView】
//  Created by 翁益亨 on 2024/7/25.
//

import Foundation
import LeanCloud

class UserModel : BaseModel{
    
    ///获取的LeanCloud的用户信息
    @Published var user : LCUser?
    
    @Published var headerImage : String = ""
    
    @Published var isToEdit : Bool = false
    @Published var isToModifyPassword : Bool = false

    //MARK: - 页面显示时重新获取一次数据
    func getUserInfo(){
        ///一般情况下获取用户信息必须存在，这里兼容异常情况
        if let user = LCApplication.default.currentUser {
            self.user = user
            self.headerImage = user.headerImage?.stringValue ?? ""
            print(user.jsonValue)
        } else {
            // 显示注册或登录页面
        }
    }
    
    //MARK: - 保存头像
    func saveHeaderImage(data: Data){
        let file = LCFile(payload: .data(data: data))
        
        file.save { result in
            switch result {
            case .success:
                if let value = file.url?.value {
                    print("文件保存完成。URL: \(value)")
                    //需要将图片关联到用户上
                    if self.user != nil{
                        self.updateImage(imageURL: value)
                    }
                }
            case .failure(error: let error):
                // 保存失败，可能是文件无法被读取，或者上传过程中出现问题
                print(error)
            }
        }
    }
    
    //MARK: - 更新对象
    func updateImage(imageURL: String){
        do {
            try self.user!.set(headerImage, value: imageURL)
            self.user!.save { (result) in
                switch result {
                case .success:
                    self.headerImage = imageURL
                case .failure(error: let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    
}
