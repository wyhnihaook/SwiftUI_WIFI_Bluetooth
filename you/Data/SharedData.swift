//
//  SharedData.swift
//  you
//  共享数据，全局统一调用内容。调用视图需要使用 @EnvironmentObject var sharedData : SharedData 来获取实例直接使用
//  Created by 翁益亨 on 2024/6/27.
//

import Foundation
import Bluejay
import SwiftUI

//将蓝牙外设的操作内容设置为共享，页面按需调用获取即可
class SharedData:BluetoothManager{
    
    //引起页面刷新。必须在每一个界面中显示的声明才能关联上页面
    @AppStorage("language") var language = String.getCurrentLanguage()

}

//注意⚠️：主题色的控制必须放到长时间显示的界面上【.preferredColorScheme(userTheme.colorCheme)】这样在@AppStore触发后能通过重新绘制界面执行preferredColorScheme方法后应用于当前应用程序中的所有页面

//1.如果需要自动适配颜色或者背景内容，就不能为文本或者容器设置固定的色值，需要让其自动根据当前设置的应用颜色变化【简单】 自定义范围 小 - 亮色、暗色
//2.如果需要手动适配，就只能通过存储的userTheme类型来判断适配【较繁琐】自定义范围 大 - 可根据需求设定多种

//如果要植入主题信息，最好都在这里做扩展统一处理展示的色值
//要实现主题色，切记！！！！不要固定写死色值
enum Theme: String, CaseIterable {
    //默认跟随系统模式
    case systemDefault = "Default"
    //亮色
    case light = "Light"
    //暗色
    case dark = "Dark"
    
    //获取对应主题的颜色色
    func color(_ scheme: ColorScheme) -> Color {
        switch self {
        case .systemDefault:
            return scheme == .dark ? .moon : .sun
        case .light:
            return .sun
        case .dark:
            return .moon
        }
    }
    
    var colorCheme: ColorScheme? {
        switch self {
        case .systemDefault:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    //Tab类型的背景色。两种示例
    func tabBgColor(_ scheme: ColorScheme) -> Color {
        switch self {
        case .systemDefault:
            return scheme == .dark ? .red : .yellow
        case .light:
            return .yellow
        case .dark:
            return .red
        }
    }
    
    //推荐属性使用方式
    var tabBgColor : Color{
        switch self {
        case .systemDefault:
            return self.colorCheme == .dark ? .red : .yellow
        case .light:
            return .yellow
        case .dark:
            return .red
        }
    }
    
    
}

