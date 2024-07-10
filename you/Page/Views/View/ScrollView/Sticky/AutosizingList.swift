//
//  AutosizingList.swift
//  you
//  实际使用示例
//  Created by 翁益亨 on 2024/7/4.
//


import SwiftUI
import SwiftUIIntrospect

public struct AutosizingList<Content: View>: View {
    
    var content: Content
    
    @State private var observation: NSKeyValueObservation?
    @State private var tableContentHeight: CGFloat = 0.0
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        List {
            content
        }
        .introspect(.list, on: .iOS(.v15)) { tableView in
            introspectScrollView(tableView)
        }
        .introspect(.list, on: .iOS(.v16, .v17)) { collectionView in
            introspectScrollView(collectionView)
        }
        .frame(height: tableContentHeight)
    }

    private func introspectScrollView(_ scrollView: UIScrollView) {
        scrollView.backgroundColor = .clear
        scrollView.isScrollEnabled = false
        tableContentHeight = scrollView.contentSize.height
        observation = scrollView.observe(\.contentSize) { scrollView, value in
            tableContentHeight = scrollView.contentSize.height
        }
    }
}
