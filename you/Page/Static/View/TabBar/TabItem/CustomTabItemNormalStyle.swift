//
//  CustomTabItemNormalStyle.swift
//  you
//  自定义图片样式内容
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI

struct CustomTabItemNormalStyle: TabItemStyle {
    
    func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> some View {
        VStack {
            Image(isSelected ? selectedIcon : icon)
                .resizable()
                .frame(width: 32.0, height: 32.0)
            
            Text(title)
                .foregroundColor(isSelected ? .black : .gray)
                .font(.system(size: 14))
        }
        .padding(.vertical, 8.0)
    }
    
}
