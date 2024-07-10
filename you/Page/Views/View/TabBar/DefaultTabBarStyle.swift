//
//  DefaultTabBarStyle.swift
//  you
//  默认情况下展示的样式
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI
public struct DefaultTabBarStyle: TabBarStyle {
    
    public func tabBar(with geometry: GeometryProxy, itemsContainer: @escaping () -> AnyView) -> some View {
        VStack(spacing: 0.0) {
            Divider()
            
            VStack {
                itemsContainer()
                    .frame(height: 50.0)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
            }
            .background(
                Color(
                    red:   249 / 255,
                    green: 249 / 255,
                    blue:  249 / 255,
                    opacity: 0.94
                )
            )
            .frame(height: 50.0 + geometry.safeAreaInsets.bottom)
        }
    }
    
}
