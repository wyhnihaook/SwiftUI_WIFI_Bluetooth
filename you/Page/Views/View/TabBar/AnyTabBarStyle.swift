//
//  AnyTabBarStyle.swift
//  you
//
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI
public struct AnyTabBarStyle: TabBarStyle {
    private let _makeTabBar: (GeometryProxy, @escaping () -> AnyView) -> AnyView
    
    public init<BarStyle: TabBarStyle>(barStyle: BarStyle) {
        self._makeTabBar = barStyle.tabBarErased
    }
    
    public func tabBar(with geometry: GeometryProxy, itemsContainer: @escaping () -> AnyView) -> some View {
        return self._makeTabBar(geometry, itemsContainer)
    }
}
