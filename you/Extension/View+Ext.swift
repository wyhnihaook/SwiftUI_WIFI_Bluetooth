//
//  View+Ext.swift
//  you
//
//  Created by 翁益亨 on 2024/6/25.
//

import Foundation
import SwiftUI

//创建顶部标题栏公用的样式
struct NavBarTextStyle : ViewModifier{
    let color:Color
  
    func body(content: Content) -> some View {
        content.font(.system(size: 14)).foregroundColor(color)
    }
}

extension View {
    func navBarTextStyle(color:Color = .red) -> some View{
        modifier(NavBarTextStyle(color: color))
    }
    
    @ViewBuilder func visibility(_ visibility: TabBarVisibility) -> some View {
        switch visibility {
        case .visible:
            self.transition(.move(edge: .bottom))
        case .invisible:
            hidden().transition(.move(edge: .bottom))
        }
    }
}
