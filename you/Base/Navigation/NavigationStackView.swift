//
//  NavigationStackView.swift
//  you
//对于NavigationStackView，这是一个问题，因为当我返回到上一个视图（使用弹出操作）时，我希望所有视图控件都与我之前离开时一样。必须@ObservableObject在需要使某些状态在推送/弹出操作之间保持时使用
//示例： @ObservedObject var loginModel = LoginModel() 要脱离当前的生命周期
//【系统API：NavigationView/NavigationLink默认会保留状态信息】
//  Created by 翁益亨 on 2024/7/24.
//


import SwiftUI

// 定义路由切换的动画效果
public enum NavigationTransition {
    /// 不需要动画效果
    case none

    /// 使用默认的切换效果 [default transition](x-source-tag://defaultTransition).
    case `default`

    /// 使用自定义转换（该转换将应用于推送和弹出操作）
    case custom(AnyTransition)

    /// 添加时从右向左滑动过渡，退出时从左向右滑动过渡。
    /// - Tag: defaultTransition
    public static var defaultTransitions: (push: AnyTransition, pop: AnyTransition) {
        let pushTrans = AnyTransition.asymmetric(insertion: .move(edge: .trailing),
                                                 removal: .move(edge: .leading))
        let popTrans = AnyTransition.asymmetric(insertion: .move(edge: .leading),
                                                removal: .move(edge: .trailing))
        return (pushTrans, popTrans)
    }
}


///模仿系统路由管理View：NavigationView 的功能进行支持
public struct NavigationStackView<Root>: View where Root: View {
    @ObservedObject private var navigationStack: NavigationStackCompat
    private let rootView: Root
    private let transitions: (push: AnyTransition, pop: AnyTransition)

    /// 创建导航堆栈视图
    public init(transitionType: NavigationTransition = .default,
                easing: Animation = NavigationStackCompat.defaultEasing,
                @ViewBuilder rootView: () -> Root) {

        self.init(transitionType: transitionType,
                  navigationStack: NavigationStackCompat(easing: easing),
                  rootView: rootView)
    }

    ///初始化路由栈基本信息，这里的rootView就是作为根页面展示内容
    public init(transitionType: NavigationTransition = .default,
                navigationStack: NavigationStackCompat,
                @ViewBuilder rootView: () -> Root) {

        self.rootView = rootView()
        self.navigationStack = navigationStack
        switch transitionType {
        case .none:
            self.transitions = (.identity, .identity)
        case .custom(let trans):
            self.transitions = (trans, trans)
        default:
            self.transitions = NavigationTransition.defaultTransitions
        }
    }

    public var body: some View {
        let showRoot = navigationStack.currentView == nil
        let navigationType = navigationStack.navigationType

        ///environmentObject作为环境对象注入，后面添加的页面都可以直接通过环境变量来访问navigationStack对象进行操作 push/pop
        return ZStack {
            Group {
                if showRoot {
                    rootView
                        .transition(navigationType == .push ? transitions.push : transitions.pop)
                        .environmentObject(navigationStack)
                } else {
                    navigationStack.currentView!.wrappedElement
                        .transition(navigationType == .push ? transitions.push : transitions.pop)
                        .environmentObject(navigationStack)
                }
            }
        }
    }
}
