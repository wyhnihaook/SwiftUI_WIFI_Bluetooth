//
//  TabBarVisibility.swift
//  you
//  控制TabBar的显示和隐藏枚举
//  Created by 翁益亨 on 2024/7/2.
//

import Foundation
public enum TabBarVisibility: CaseIterable {
  
    case visible
    
    case invisible
    
   
    public mutating func toggle() {
        switch self {
        case .visible:
            self = .invisible
        case .invisible:
            self = .visible
        }
    }
}
