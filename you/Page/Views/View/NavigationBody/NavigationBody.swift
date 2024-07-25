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
    //结合了自定义导航使用
//    @EnvironmentObject private var navigationStack: NavigationStackCompat
    
    //标题信息
    private let title : String
    
    //点击返回到回调信息
    private let backCallback : (()->Void)?
    
    //右侧功能块，数组获取外部同步而来，因为右侧的按钮信息根据页面不同而做不同操作
    private var items: TrailingView
    
    //核心展示的内容
    private let content: Content

    public init(title: String,  @ViewBuilder item: () -> TrailingView, @ViewBuilder content: () -> Content, backCallback: (()->Void)? = nil) {
        self.backCallback = backCallback
        self.title = title
        self.content = content()
        self.items = item()
    }
    
    var body: some View{
        //封装顶部标题栏信息
        VStack(spacing:0){
            HStack {
                Button{
                    //当前是返回一级。如果要返回多级就需要for循环次数来返回。这里可以让用户来控制返回层级
                    //【返回视觉效果较差。一级一级返回】
//                    presentationMode.wrappedValue.dismiss()
                    
                    //默认不需要自定义返回方法，只往上回退一步
                    if backCallback != nil{
                        backCallback!()
                    }else{
//                        navigationStack.pop()
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                }label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }.frame(width: 50,alignment: .leading)
                .padding()
                
                //文本内容
                Text(title).foregroundColor(.black).font(.system(size: 18)).frame(maxWidth: .infinity)
                
                //预留空间
                ZStack{
                    Rectangle().fill(Color.clear).frame(width: 50)
                    self.items
                }.frame(alignment: .trailing).padding()
                
            }.frame(height: 44)
            
            content
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
        }
        //隐藏导航配置顶部信息
        .navigationBarHidden(true)
        
//        一个APP中遵守只使用一个NavigationView的约定
//        NavigationView {
//            //设置内容的尺寸信息占满剩余空间内容即可
//
//
//        }
//        //默认的标题展示样式.必须设置，主要是要让displayMode设置为.inline和标题栏一致。这样消除默认存在的标题栏下方的文本内容【主要是消除内容高度】
//        .navigationBarTitle("",displayMode:.inline)
//        .navigationBarBackButtonHidden()
//        .toolbar{
//            //左侧按钮功能
//            ToolbarItem(placement: .navigationBarLeading) {
//                //显示的返回按钮信息
//                Button{
//                    presentationMode.wrappedValue.dismiss()
//                }label: {
//                    Image(systemName: "chevron.backward")
//                        .foregroundColor(.black)
//                }
//            }
//
//            ToolbarItem(placement: .principal) {
//                Text(title).foregroundColor(.black).font(.system(size: 18))
//            }
//
//            //右侧按钮功能
//            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                self.items
////                Text("右侧按钮").font(.system(size: 14)).foregroundColor(.black)
////                Text("右侧按钮").font(.system(size: 14)).foregroundColor(.black)
//            }
//
////            ToolbarItem(placement: .navigationBarTrailing) {
////                Text("右侧按钮").font(.system(size: 14)).foregroundColor(.black)
////            }
//        }
        
    }
}


