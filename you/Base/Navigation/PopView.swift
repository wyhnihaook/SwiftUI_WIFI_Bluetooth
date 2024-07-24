//
//  PopView.swift
//  you
//  Navigation 功能扩展【定义Pop返回到页面】- 直接使用只支持单页面返回。扩展多级/指定页面返回
//  Created by 翁益亨 on 2024/7/24.
//

import SwiftUI

//MARK: - 定义返回的调用方法
public enum PopDestination {
    /// 返回到上个页面
    case previous

    /// 返回到路由栈到根部
    case root

    /// 根据传递到ID锁定返回到的页面
    case view(withId: String)
}



public struct PopView<Label, Tag>: View where Label: View, Tag: Hashable {
    @EnvironmentObject private var navigationStack: NavigationStackCompat
    private let label: Label
    private let destination: PopDestination
    private let tag: Tag?
    @Binding private var isActive: Bool
    @Binding private var selection: Tag?

    
    public init(destination: PopDestination = .previous,
                tag: Tag, selection: Binding<Tag?>,
                @ViewBuilder label: () -> Label) {

        self.init(destination: destination,
                  isActive: Binding.constant(false),
                  tag: tag,
                  selection: selection,
                  label: label)
    }

    private init(destination: PopDestination,
                 isActive: Binding<Bool>, tag: Tag?,
                 selection: Binding<Tag?>,
                 @ViewBuilder label: () -> Label) {

        self.label = label()
        self.destination = destination
        self._isActive = isActive
        self._selection = selection
        self.tag = tag
    }

    public var body: some View {
        if let selection = selection, let tag = tag, selection == tag {
            DispatchQueue.main.async {
                self.selection = nil
                pop()
            }
        }
        if isActive {
            DispatchQueue.main.async {
                isActive = false
                pop()
            }
        }
        return label.onTapGesture {
            pop()
        }
    }

    private func pop() {
        navigationStack.pop(to: destination)
    }
}
