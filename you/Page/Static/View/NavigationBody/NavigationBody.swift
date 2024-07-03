//
//  NavigationBody.swift
//  you
//  导航器功能封装.【一个APP应用请遵守 只使用一个 NavigationView】
//  Created by 翁益亨 on 2024/7/3.
//

import Foundation
import SwiftUI

struct NavigationBody<TrailingView : View, Content: View> : View{
    
    //获取全局环境中的导航器功能。让当前的View获取了presentationMode属性的绑定数据。用于返回上级页面
    //【全局环境配置的变量，可以直接到获取】
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //标题信息
    private let title : String
    
    //右侧功能块，数组获取外部同步而来，因为右侧的按钮信息根据页面不同而做不同操作
    private var items: TrailingView
    
    //核心展示的内容
    private let content: Content

    public init(title: String, @ViewBuilder item: () -> TrailingView, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
        self.items = item()
    }
    
    var body: some View{
        NavigationView {
            //设置内容的尺寸信息占满剩余空间内容即可
            content
                .frame(maxWidth: .infinity)
                .navigationBarHidden(true)
                
        }
        //默认的标题展示样式.必须设置，主要是要让displayMode设置为.inline和标题栏一致。这样消除默认存在的标题栏下方的文本内容【主要是消除内容高度】
        .navigationBarTitle("",displayMode:.inline)
        .navigationBarBackButtonHidden()
        .toolbar{
            //左侧按钮功能
            ToolbarItem(placement: .navigationBarLeading) {
                //显示的返回按钮信息
                Button{
                    presentationMode.wrappedValue.dismiss()
                }label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(title).foregroundColor(.black).font(.system(size: 18))
            }
            
            //右侧按钮功能
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                self.items
//                Text("右侧按钮").font(.system(size: 14)).foregroundColor(.black)
//                Text("右侧按钮").font(.system(size: 14)).foregroundColor(.black)
            }
            
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Text("右侧按钮").font(.system(size: 14)).foregroundColor(.black)
//            }
        }
        
    }
}


