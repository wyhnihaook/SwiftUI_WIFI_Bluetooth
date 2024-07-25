//
//  MineModel.swift
//  you
//
//  Created by 翁益亨 on 2024/7/25.
//

import Foundation
import LeanCloud

class MineModel : BaseModel{
    ///获取的LeanCloud的用户信息
    @Published var user : LCUser?
    
    @Published var headerImage : String = ""

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
    
}
