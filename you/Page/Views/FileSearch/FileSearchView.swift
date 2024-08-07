
//
//  FileSearchView.swift
//  you
//  文件搜索功能
//  Created by 翁益亨 on 2024/8/6.
//

import SwiftUI

struct FileSearchView: View {
    //文件页面的数据模型
    @StateObject private var model = FileSearchModel()

    //用于关闭当前页面
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack(spacing:0){
            HStack {
                TextField("在文件中搜索",text:$model.filename,
                          prompt: Text("在文件中搜索").font(.system(size: 16)))
                .frame(height: 44)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 40))
                .background(Color(hexString: "#F6F7F9"))
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                .overlay(content: {
                    //创建一个视图容器显示在页面上
                    //视图尺寸遵循调用者的尺寸，简单理解为一个便捷的ZStack
                    RoundedRectangle(cornerRadius: 10).stroke(Color(hexString: "#E9E9E9")!, lineWidth: 1)

                })


                Button{
                    presentationMode.wrappedValue.dismiss()

                }label: {
                    Text("取消").font(Font.system(size:14)).foregroundColor(.gray)
                }.frame(width: 40,alignment: .trailing)


            }.padding(15)

            //分类

            HStack(spacing:10){
                //显示当前的选择类型
                Group{
                    //选择后展示选择的内容
                    createCategory("创建时间").onTapGesture {
                        FileFilterCreateTimePopup().showAndStack()

                    }

                }.padding(.horizontal, 10).frame(maxWidth:.infinity,maxHeight:40).background(Color.color_f6f7f9).cornerRadius(4)


                Group{
                    createCategory("文件位置").onTapGesture {

                    }

                }.padding(.horizontal, 10).frame(maxWidth:.infinity,maxHeight:40).background(Color.color_f6f7f9).cornerRadius(4)

                Group{
                    createCategory("转写状态").onTapGesture {

                    }

                }.padding(.horizontal, 10).frame(maxWidth:.infinity,maxHeight:40).background(Color.color_f6f7f9).cornerRadius(4)

            }.padding([.bottom,.horizontal], 15)

            //筛选结果
            //默认展示的是最近搜索内容

            ScrollView(showsIndicators:false){

                

            }.frame(maxWidth:.infinity,maxHeight:.infinity)
        }
        //隐藏导航配置顶部信息
        .navigationBarHidden(true)
    }
}

extension FileSearchView{
    func createCategory(_ title:String) -> some View{
        HStack(spacing:6){
            Text(title).font(.system(size:14))

            Image("icon_noise_reduction")
                .resizable()
                .frame(width: 12,height:12)
        }
    }
}

struct FileSearchView_Previews: PreviewProvider {
    static var previews: some View {
        FileSearchView()
    }
}

