//
//  SharedData.swift
//  you
//  共享数据，全局统一调用内容。调用视图需要使用 @EnvironmentObject var sharedData : SharedData 来获取实例直接使用
//  Created by 翁益亨 on 2024/6/27.
//

import Foundation
import Bluejay
import SwiftUI

class SharedData:ObservableObject{
    ///创建蓝牙管理类的唯一实例
    static let bluejay = Bluejay()
    
    //引起页面刷新。必须在每一个界面中显示的声明才能关联上页面
    @AppStorage("language") var language = String.getCurrentLanguage()

}
