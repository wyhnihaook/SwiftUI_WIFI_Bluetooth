//
//  HomeTabBar.swift
//  you
//  首页Tabbar类型设定
//  Created by 翁益亨 on 2024/7/9.
//

import SwiftUI

public protocol HomeTabbable: Hashable {
    ///TabView默认的显示图片
    var icon: String { get }
    
    /// TabView选中后的显示图片
    var selectedIcon: String { get }
    
    /// TabView的标题
    var title: String { get }
}


//这里的String使用来设置rawValue获取的结果【file.rawValue获取的是file字符串类型】
enum HomeTabBar : String, HomeTabbable{
    
    case file = "file"
    case mine = "mine"
    
    var icon: String {
        switch self {
            case .file: return "icon_file_unselect"
            case .mine: return "icon_file_unselect"

        }
    }

    var selectedIcon: String {
        switch self {
            case .file: return "icon_file_select"
            case .mine: return "icon_file_select"

        }
    }


    var title: String {
        switch self {
            case .file: return "文件"
            case .mine: return "我"
        }
    }
}


//MARK: - 关联数据的组件数据展示
struct HomeTabBarView : View{
    
    let item : HomeTabBar
    
    let isSelected : Bool
    
    var body: some View{
        VStack(spacing:0) {
            Image(isSelected ? item.selectedIcon : item.icon)
                .resizable()
                .frame(width: 28.0, height: 28.0)
            
            Text(item.title)
//                .foregroundColor(isSelected ? .black : .gray)
                .font(.system(size: 13))
        }
        .padding(.vertical, 4.0)
    }
}
