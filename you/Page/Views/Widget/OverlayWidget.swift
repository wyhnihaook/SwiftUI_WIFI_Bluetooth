//
//  OverlayWidget.swift
//  you
//  overlay中绝对定位的布局处理
//  Created by 翁益亨 on 2024/7/23.
//

import SwiftUI

//MARK: - 外部同步传递的本地图片信息
struct ImageInfo{
    let imageUrl : String
    let width : Double
    let height :Double
}

func RightImageWidget(imageInfo: ImageInfo, onTapGesture:@escaping () -> Void) -> some View{
    return HStack{
        Spacer()
        Image(imageInfo.imageUrl)
            .resizable().frame(width: imageInfo.width, height: imageInfo.height).onTapGesture(perform: onTapGesture)
        Spacer().frame(width: 15)
    }
}

