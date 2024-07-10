//
//  NonBouncyScrollView.swift
//  you
//  没有弹性的滚动组件
//  Created by 翁益亨 on 2024/7/2.
//

import SwiftUI
import UIKit

struct NonBouncyScrollView<Content>: UIViewRepresentable where Content: View {
    let content: () -> Content
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false // 禁止弹性滚动
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        let hostedView = UIHostingController(rootView: content())
        hostedView.view.backgroundColor = .clear // 可选，确保背景透明
        hostedView.view.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(hostedView.view)
        
        // 使用NSLayoutConstraint确保SwiftUI视图充满UIScrollView
        NSLayoutConstraint.activate([
            hostedView.view.topAnchor.constraint(equalTo: uiView.topAnchor),
            hostedView.view.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
            //约束左右可能导致宽度显示不完整问题，使用下方宽度约束来解决
//            hostedView.view.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
//            hostedView.view.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            
            //注意：这里一定要约束宽度为容器的宽度，避免上述尺寸左右约束后宽度显示不是整屏宽度问题
            hostedView.view.widthAnchor.constraint(equalTo:uiView.widthAnchor),

        ])
    }
}
