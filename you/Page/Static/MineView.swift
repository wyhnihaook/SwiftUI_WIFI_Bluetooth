//
//  MineView.swift
//  you
//
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI

struct MineView: View {
    var body: some View {
        NavigationView{
            List{
                NavigationLink(destination: WiFiView()) {
                    FuncItem(title: "转写记录", image: "icon_file_select")
                }
                                
                NavigationLink(destination: WiFiView()) {
                    FuncItem(title: "PLAUD CLOUD", image: "icon_file_select", desc: "关闭")
                }
                
                
                NavigationLink(destination: WiFiView()) {
                    FuncItem(title: "我的PLAUD NOTE", image: "icon_file_select")
                }
                
                
                NavigationLink(destination: WiFiView()) {
                    FuncItem(title: "帮助和反馈", image: "icon_file_select")
                }
                
                NavigationLink(destination: WiFiView()) {
                    FuncItem(title: "关于PLAUD", image: "icon_file_select", desc: "v2.0.10(109)")
                }
            }
            
        }
    }
}

struct MineView_Previews: PreviewProvider {
    static var previews: some View {
        MineView()
    }
}

//图片 + 文字内容
struct FuncItem:View{
    let title : String
    let image : String
    let desc : String
    
    init(title: String, image: String, desc: String = "") {
        self.title = title
        self.image = image
        self.desc = desc
    }
    
    var body: some View{
        HStack{
            Image(image)
                .resizable()
                .frame(width: 20, height: 20)
            
            Spacer().frame(width: 10)
            
            Text(title)
                .foregroundColor(.black)
                .font(.system(size: 16))
            
            
            
            //额外信息
            if !desc.isEmpty{
                Spacer()
                Text(desc)
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            
            
        }.padding(.vertical, 6)
    }
}
