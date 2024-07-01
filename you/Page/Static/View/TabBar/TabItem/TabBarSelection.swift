//
//  TabBarSelection.swift
//  you
//
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI
class TabBarSelection<TabItem: Tabbable>: ObservableObject {
    @Binding var selection: TabItem
    
    init(selection: Binding<TabItem>) {
        self._selection = selection
    }
}
