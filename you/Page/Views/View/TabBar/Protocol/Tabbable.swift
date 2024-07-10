//
//  Tabbable.swift
//  you
//  自定义底部显示内容的协议
//  Created by 翁益亨 on 2024/7/1.
//

import Foundation

public protocol Tabbable: Hashable {
    ///TabView默认的显示图片
    var icon: String { get }
    
    /// TabView选中后的显示图片
    var selectedIcon: String { get }
    
    /// TabView的标题
    var title: String { get }
}

public extension Tabbable {
//    var selectedIcon: String {
//        return self.icon
//    }
}
