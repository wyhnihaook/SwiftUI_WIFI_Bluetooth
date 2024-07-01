//
//  CustomTabBarWhiteStyle.swift
//  you
//
//  Created by 翁益亨 on 2024/7/1.
//


import SwiftUI

struct CustomTabBarWhiteStyle: TabBarStyle {
    
    public func tabBar(with geometry: GeometryProxy, itemsContainer: @escaping () -> AnyView) -> some View {
        itemsContainer()
            .background(.white)
            .frame(height: 50.0)
            .padding(.bottom, geometry.safeAreaInsets.bottom)
    }
    
}
