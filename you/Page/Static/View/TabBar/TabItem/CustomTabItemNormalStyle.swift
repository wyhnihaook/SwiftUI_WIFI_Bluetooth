//
//  CustomTabItemNormalStyle.swift
//  you
//  自定义图片样式内容
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI

struct CustomTabItemNormalStyle: TabItemStyle {
    
    func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> some View {
        VStack(spacing:0) {
            Image(isSelected ? selectedIcon : icon)
                .resizable()
                .frame(width: 28.0, height: 28.0)
            
            Text(title)
                .foregroundColor(isSelected ? .black : .gray)
                .font(.system(size: 13))
        }
        .padding(.vertical, 8.0)
    }
    
}
