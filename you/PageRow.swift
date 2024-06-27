//
//  PageRow.swift
//  you
//  显示跳转的公共样式组件
//  Created by 翁益亨 on 2024/6/25.
//

import SwiftUI

struct PageRow: View {
    
    let title:String
    let subTitle:String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0){
            Text(title).font(.subheadline)
            if subTitle != nil{
                Text(subTitle!).foregroundColor(.gray).font(.system(size:12))
            }
        }.foregroundColor(.black)
    }
}

struct PageRow_Previews: PreviewProvider {
    static var previews: some View {
        PageRow(title: "主标题", subTitle: "副标题")
    }
}
