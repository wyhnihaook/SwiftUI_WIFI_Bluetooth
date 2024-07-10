//
//  FileDetailTabBar.swift
//  you
//
//  Created by 翁益亨 on 2024/7/9.
//


import SwiftUI

public protocol FileDetailTabbable: Hashable {
    ///TabView默认的颜色
    var color: Color { get }
    
    /// TabView选中后的颜色
    var selectedColor: Color { get }
    
    /// TabView的标题
    var title: String { get }
}


//这里的String使用来设置rawValue获取的结果【file.rawValue获取的是file字符串类型】
enum FileDetailTabBar : String, FileDetailTabbable{
    
    case transfer = "transfer"
    case summarize = "summarize"
    case mindMap = "mindMap"

    var color: Color {
        return Color(hexString: "#00FF00")!
    }

    var selectedColor: Color {
       return Color(hexString: "#FF0000")!
    }


    var title: String {
        switch self {
            case .transfer: return "转写"
            case .summarize: return "总结"
            case .mindMap: return "思维导图"
        }
    }
}


//MARK: - 关联数据的组件数据展示
struct FileDetailTabBarView : View{
    
    let item : FileDetailTabBar
    
    let isSelected : Bool
    
    var body: some View{
        ZStack() {
            
            if isSelected {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.white)
                    .frame(width: 90.0, height: 40.0)
            }
            
            Text(item.title)
                .foregroundColor(isSelected ? item.selectedColor : item.color)
                .font(.system(size: 13))
                .frame(width: 90.0, height: 40.0,alignment: .center)
        }
        .padding(.vertical, 4.0)
    }
}
