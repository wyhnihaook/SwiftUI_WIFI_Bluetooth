//
//  BaseModel.swift
//  you
//  所有视图都应该拥有Model，所有的Model都继承当前基类，用于持有公共的需要界面响应的资源
//  Created by 翁益亨 on 2024/7/22.
//
import SwiftUI
import Foundation

class BaseModel : ObservableObject{
    //引起页面刷新。必须在每一个界面中显示的声明才能关联上页面
    @AppStorage("language") var language = String.getCurrentLanguage()
}
