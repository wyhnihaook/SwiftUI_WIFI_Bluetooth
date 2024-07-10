//
//  TextSizeView.swift
//  you
//
//  Created by 翁益亨 on 2024/7/10.
//

import SwiftUI
//文本自定义内容获取尺寸同步外部数据。文本和关键字内容
struct TextSizeView : View {
    let maxWidth : Double
    let text : String
    
    var body: some View{
        Text(text)
            .modifier(MindMapTextStyle())
            .frame(maxWidth:maxWidth,alignment:.topLeading)
            .padding(.horizontal,1)
    }
}


//文本展示统一样式
struct MindMapTextStyle : ViewModifier{
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .font(.system(size: 10))
    }
}


//文本自定义内容获取尺寸同步外部数据。文本和关键字内容
struct TextCalcSizeView : View {
    let maxWidth : Double
    let text : String
    //内容处理同步
    let index : Int
    
    //绑定父视图的数据源来进行修改。同步之后
    @Binding var textSizeList : [MindMapTextSize]
    
    var body: some View{
        Text(text)
            .modifier(MindMapTextStyle())
            .background(GeometryReader{
                gp in
                Color.clear.onAppear{
                    //gp.size.width - gp.size.height

                    //兼容尺寸10
                    textSizeList.append(MindMapTextSize(text:text,occupyWidth:  gp.size.width + 2, occupyHeight: gp.size.height))
                }
            })
            .frame(maxWidth:maxWidth,alignment:.topLeading)
            .padding(.horizontal,1)
            
    }
}


struct TextCalcSingleSizeView : View {
    let maxWidth : Double
    let text : String

    
    //绑定父视图的数据源来进行修改。同步之后
    @Binding var textSize : MindMapTextSize
    
    var body: some View{
        Text(text)
            .modifier(MindMapTextStyle())
            .background(GeometryReader{
                gp in
                Color.clear.onAppear{
                    //gp.size.width - gp.size.height
                    //兼容尺寸10
                    textSize = MindMapTextSize(text:text,occupyWidth:  gp.size.width + 2, occupyHeight: gp.size.height)
                }
            })
            .frame(maxWidth:maxWidth,alignment:.topLeading)
            .padding(.horizontal,1)
            
    }
}




