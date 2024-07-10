//
//  TabBarPreferenceKey.swift
//  you
//
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI
struct TabBarPreferenceKey<TabItem: Tabbable>: PreferenceKey {
    static var defaultValue: [TabItem] {
        return .init()
    }
    
    static func reduce(value: inout [TabItem], nextValue: () -> [TabItem]) {
        value.append(contentsOf: nextValue())
    }
}
