//
//  NavigationStackCompat.swift
//  you
//  路由基础组件，
//  Created by 翁益亨 on 2024/7/24.
//


import SwiftUI

//MARK: - 提供导航方法。添加/退出 路由
enum NavigationType {
    case push
    case pop
}

//MARK: - 创建监视器来同步页面上的内容 ObservableObject + @Published
public class NavigationStackCompat: ObservableObject {

    /// 出现/隐藏的过渡默认动画
    public static let defaultEasing = Animation.easeOut(duration: 0.2)

    @Published var currentView: ViewElement?
    @Published private(set) var navigationType = NavigationType.push
    private let easing: Animation

    /// 外部同步切换的动画效果
    public init(easing: Animation = defaultEasing) {
        self.easing = easing
    }

    private var viewStack = ViewStack() {
        didSet {
            currentView = viewStack.peek()
        }
    }

    /// 路由栈的深度获取。根路由的深度为0
    public var depth: Int {
        viewStack.depth
    }

    /// 判断路由栈中是否包含当前的页面信息
    public func containsView(withId id: String) -> Bool {
        viewStack.indexForView(withId: id) != nil
    }

    /// 路由栈添加页面【如果页面可以多开并且没有返回定位关联可以考虑不传递id信息】
    public func push<Element: View>(_ element: Element, withId identifier: String? = nil) {
        navigationType = .push
        withAnimation(easing) {
            viewStack.push(ViewElement(id: identifier == nil ? UUID().uuidString : identifier!,
                                       wrappedElement: AnyView(element)))
        }
    }

    /// 返回页面功能【多级/单级/定向返回】
    public func pop(to: PopDestination = .previous) {
        navigationType = .pop
        withAnimation(easing) {
            switch to {
            case .root:
                viewStack.popToRoot()
            case .view(let viewId):
                viewStack.popToView(withId: viewId)
            default:
                viewStack.popToPrevious()
            }
        }
    }
}

private struct ViewStack {
    
    ///路由栈信息
    private var views = [ViewElement]()

    ///获取当前页面的ViewElement信息
    func peek() -> ViewElement? {
        views.last
    }

    ///页面的深度获取。从根页面开始计算为0，新增一个页面 +1 。所以回到根页面后，深度为0
    var depth: Int {
        views.count
    }

    ///添加显示页面
    mutating func push(_ element: ViewElement) {
        guard indexForView(withId: element.id) == nil else {
            print("Duplicated view identifier: \"\(element.id)\". You are trying to push a view with an identifier that already exists on the navigation stack.")
            return
        }
        views.append(element)
    }

    ///返回到上一级页面。关闭队列的最后一个页面
    mutating func popToPrevious() {
        _ = views.popLast()
    }

    ///回退到固定的页面
    mutating func popToView(withId identifier: String) {
        guard let viewIndex = indexForView(withId: identifier) else {
            print("Identifier \"\(identifier)\" not found. You are trying to pop to a view that doesn't exist.")
            return
        }
        views.removeLast(views.count - (viewIndex + 1))
    }

    ///回退到根页面
    mutating func popToRoot() {
        views.removeAll()
    }

    ///页面查询对应的ID信息，用于定位
    func indexForView(withId identifier: String) -> Int? {
        views.firstIndex {
            $0.id == identifier
        }
    }
}

//Equatable:用于视图重绘时机执行的协议【多用于以组件形式存在页面中的View每次页面数据变化被强制刷新的情况可以使用】
//这里为每一个页面都设定唯一的id【使用页面设置的id最好要保持一致】
struct ViewElement: Identifiable, Equatable {
    let id: String
    let wrappedElement: AnyView

    //根据是否和之前的视图有偏差，如果是 - 不刷新视图 。 否 - 刷新视图
    static func == (lhs: ViewElement, rhs: ViewElement) -> Bool {
        lhs.id == rhs.id
    }
}

