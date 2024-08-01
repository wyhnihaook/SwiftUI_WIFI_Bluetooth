//
//  Screen+Ext.swift
//  you
//
//  Created by 翁益亨 on 2024/8/1.
//

import SwiftUI
class Screen {
    static var safeArea: UIEdgeInsets = UIScreen.safeArea
}
fileprivate extension UIScreen {
    static var safeArea: UIEdgeInsets {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .safeAreaInsets ?? .zero
    }
}
