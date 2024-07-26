//
//  EditModel.swift
//  you
//
//  Created by 翁益亨 on 2024/7/25.
//

import Foundation
import LeanCloud
import SwiftUI

class EditModel : BaseModel{
    
    @Published var modifyUsername : String = ""
    
    //MARK: - 更新对象。首先获取对象 - 去更新后save
    func updateUsername(callback: @escaping ()->Void){
        if let user = LCApplication.default.currentUser {
                    do {
                        try user.set("username", value: modifyUsername)
                        user.save { (result) in
                            switch result {
                            case .success:
                                //提示保存完成后返回页面
                                callback()
                            case .failure(error: let error):
                                print(error)
                            }
                        }
                    } catch {
                        print(error)
                    }
        } else {
            // 显示注册或登录页面
        }

    }
}
