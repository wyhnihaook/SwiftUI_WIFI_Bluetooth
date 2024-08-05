//
//  View+Ext.swift
//  you
//
//  Created by 翁益亨 on 2024/6/25.
//

import Foundation
import SwiftUI

//MARK: - 创建顶部标题栏公用的样式
struct NavBarTextStyle : ViewModifier{
    let color:Color
  
    func body(content: Content) -> some View {
        content.font(.system(size: 14)).foregroundColor(color)
    }
}

//MARK: - 按钮功能点击适配
struct ButtonPressStyle:ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

extension View {
    @ViewBuilder func active(_ condition: Bool) -> some View {
        if condition { self }
    }
    
    func frame(_ size: CGFloat) -> some View { frame(width: size, height: size, alignment: .center) }
    
    func alignHorizontally(_ alignment: HorizontalAlignment, _ value: CGFloat = 0) -> some View {
        HStack(spacing: 0) {
            Spacer.width(alignment == .leading ? value : nil)
            self
            Spacer.width(alignment == .trailing ? value : nil)
        }
    }
    
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
    
    func withPressStyle()->some View{
        buttonStyle(ButtonPressStyle())
    }
}


//MARK: - 弹窗标题栏样式
struct PopupTitleStyle : ViewModifier{
  
    func body(content: Content) -> some View {
        content.font(.system(size: 18)).foregroundColor(.black)
    }
}

//MARK: - 弹窗描述内容
struct PopupDescStyle : ViewModifier{
  
    func body(content: Content) -> some View {
        content.font(.system(size: 16)).foregroundColor(.black).frame(maxWidth:.infinity,alignment: .leading)
    }
}

//MARK: - 弹窗提示内容
struct PopupContentStyle : ViewModifier{
  
    func body(content: Content) -> some View {
        content.font(.system(size: 12)).foregroundColor(.gray).frame(maxWidth:.infinity,alignment: .leading)
    }
}



struct SizeGetter: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy -> Color in
                    if proxy.size != self.size {
                        DispatchQueue.main.async {
                            self.size = proxy.size
                        }
                    }
                    return Color.clear
                }
            )
    }
}

extension View {
    public func sizeGetter(_ size: Binding<CGSize>) -> some View {
        modifier(SizeGetter(size: size))
    }
}
