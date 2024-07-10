//
//  AnyTabItemStyle.swift
//  you
//
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI
public struct AnyTabItemStyle: TabItemStyle {
    private let _makeTabItem: (String, String, String, Bool) -> AnyView
    
    public init<TabItem: TabItemStyle>(itemStyle: TabItem) {
        self._makeTabItem = itemStyle.tabItemErased(icon:selectedIcon:title:isSelected:)
    }
    
    public func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> some View {
        return self._makeTabItem(icon, selectedIcon, title, isSelected)
    }
}
