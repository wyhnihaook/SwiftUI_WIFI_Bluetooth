//
//  CustomTabItemStyle.swift
//  you
//  自定义TabItem的显示样式【当Tab切换时控制展示内容的显示和隐藏】
//  Created by 翁益亨 on 2024/7/1.
//

import Foundation
import SwiftUI

struct TabBarViewModifier<TabItem: Tabbable>: ViewModifier {
    @EnvironmentObject private var selectionObject: TabBarSelection<TabItem>
    
    let item: TabItem
    
    func body(content: Content) -> some View {
        Group {
            if self.item == self.selectionObject.selection {
                content
            } else {
                Color.clear
            }
        }
        .preference(key: TabBarPreferenceKey.self, value: [self.item])
    }
}

extension View {
    ///挂载到View上的设置tabItem样式的方法
    public func tabItem<TabItem: Tabbable>(for item: TabItem) -> some View {
        return self.modifier(TabBarViewModifier(item: item))
    }
}
