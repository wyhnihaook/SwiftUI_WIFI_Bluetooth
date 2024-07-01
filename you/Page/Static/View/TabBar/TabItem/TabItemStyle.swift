//
//  TabItemStyle.swift
//  you
//
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI
public protocol TabItemStyle {
    associatedtype Content : View
    
    func tabItem(icon: String, title: String, isSelected: Bool) -> Content
    func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> Content
}

extension TabItemStyle {
    public func tabItem(icon: String, title: String, isSelected: Bool) -> Content {
        return self.tabItem(icon: icon, selectedIcon: icon, title: title, isSelected: isSelected)
    }
    
    public func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> Content {
        return self.tabItem(icon: icon, title: title, isSelected: isSelected)
    }
    
    func tabItemErased(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> AnyView {
        return .init(self.tabItem(icon: icon, selectedIcon: selectedIcon, title: title, isSelected: isSelected))
    }
}
