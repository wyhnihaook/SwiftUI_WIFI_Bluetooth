//
//  DefaultTabItemStyle.swift
//  you
//
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI
public struct DefaultTabItemStyle: TabItemStyle {
    public func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> some View {
        VStack(spacing: 5.0) {
            Image(systemName: icon)
                .renderingMode(.template)
            
            Text(title)
                .font(.system(size: 10.0, weight: .medium))
        }
        .foregroundColor(isSelected ? .accentColor : .gray)
    }
}

