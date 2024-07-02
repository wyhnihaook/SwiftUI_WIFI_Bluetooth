//
//  TabBar.swift
//  you
//  自定义容器
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI
public struct TabBar<TabItem: Tabbable, Content: View>: View {
    
    private let selectedItem: TabBarSelection<TabItem>
    private let content: Content
    
    private var tabItemStyle : AnyTabItemStyle
    private var tabBarStyle  : AnyTabBarStyle
    
    @State private var items: [TabItem]
    @Binding private var visibility: TabBarVisibility

    /**
     初始化根据传递的TabItem来设定显示内容
     */
    public init(
        selection: Binding<TabItem>,
        visibility: Binding<TabBarVisibility> = .constant(.visible),
        @ViewBuilder content: () -> Content
    ) {
        self.tabItemStyle = .init(itemStyle: DefaultTabItemStyle())
        self.tabBarStyle = .init(barStyle: DefaultTabBarStyle())
        
        self.selectedItem = .init(selection: selection)
        self.content = content()
        
        self._items = .init(initialValue: .init())
        self._visibility = visibility

    }
    
    private var tabItems: some View {
        HStack {
            ForEach(self.items, id: \.self) { item in
                self.tabItemStyle.tabItem(
                    icon: item.icon,
                    selectedIcon: item.selectedIcon,
                    title: item.title,
                    isSelected: self.selectedItem.selection == item
                )
                .onTapGesture {
                    self.selectedItem.selection = item
                    self.selectedItem.objectWillChange.send()
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    public var body: some View {
        ZStack {
            self.content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environmentObject(self.selectedItem)
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    self.tabBarStyle.tabBar(with: geometry) {
                        .init(self.tabItems)
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                .visibility(self.visibility)
            }
        }
        .onPreferenceChange(TabBarPreferenceKey.self) { value in
            self.items = value
        }
    }
    
}

extension TabBar {
    /**
     *   设定扩展方法，设定对应的标签的显示样式
     */
    public func tabItem<ItemStyle: TabItemStyle>(style: ItemStyle) -> Self {
        var _self = self
        _self.tabItemStyle = .init(itemStyle: style)
        return _self
    }
    
    /**
     * 设定扩展方法，设定当前的容器的样式
     */
    public func tabBar<BarStyle: TabBarStyle>(style: BarStyle) -> Self {
        var _self = self
        _self.tabBarStyle = .init(barStyle: style)
        return _self
    }
}

