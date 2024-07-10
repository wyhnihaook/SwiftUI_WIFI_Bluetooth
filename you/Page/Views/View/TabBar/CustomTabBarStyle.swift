//
//  CustomTabBarStyle.swift
//  you
//
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI

struct CustomTabBarStyle: TabBarStyle {
    
    public func tabBar(with geometry: GeometryProxy, itemsContainer: @escaping () -> AnyView) -> some View {
        itemsContainer()
            .background(Color(hexString: "#F7F8F9"))
            .cornerRadius(10.0)
            .frame(height: 50.0)
            .padding(.horizontal, 20)
            .padding(.top, 16.0 )
    }
    
}
