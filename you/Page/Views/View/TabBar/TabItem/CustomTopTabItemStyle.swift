//
//  CustomTopTabItemStyle.swift
//  you
//  顶部标题选中模式
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI

struct CustomTopTabItemStyle: TabItemStyle {
    
    public func tabItem(icon: String, title: String, isSelected: Bool) -> some View {
        ZStack {
            if isSelected {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.white)
                    .frame(width: 90.0, height: 40.0)
            }
            
            Text(title)
        }
        .padding(.vertical, 8.0)
    }
    
}
