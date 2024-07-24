//
//  MineView.swift
//  you
//
//  Created by 翁益亨 on 2024/7/1.
//

import SwiftUI

var rectSize = 6.0

struct MineView: View {
    //设置可滚动的GridItem内容。最大行数设定 7行
    let rows :[GridItem] = [
        GridItem(.fixed(rectSize),spacing:2),
        GridItem(.fixed(rectSize),spacing:2),
        GridItem(.fixed(rectSize),spacing:2),
        GridItem(.fixed(rectSize),spacing:2),
        GridItem(.fixed(rectSize),spacing:2),
        GridItem(.fixed(rectSize),spacing: 2),
        GridItem(.fixed(rectSize),spacing: 2)]
    
    //数据源内容 7*40
    let colum = 0...380

    
    var body: some View {
        NonBouncyScrollView{
            //设置每个布局的间距
            VStack(spacing:12){
                Spacer().frame(height: 20)
                //用户基本信息
                NavigationLink(destination: UserInfoView()) {
                    HStack{
                        Image("icon_head_default")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        Spacer().frame(width: 10)
                        VStack(alignment:.leading){
                            Text("nihao")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .bold()
                            Spacer().frame(height: 2)
                            
                            Text(verbatim:"www.baidu.com").foregroundColor(.gray)
                                .font(.system(size: 13))
                                
                        }
                        
                        Spacer()
                        //箭头
                        Image("icon_arrow").resizable().frame(width:15, height: 15)
                    }
                }
                
                Spacer().frame(height: 4)
                //具体操作内容记录
                VStack(spacing:8){
                    HStack(spacing: 5) {
                        //内容设置.infinity就会尽可能占多大位置。类似权重的设置
                        LabelRichText(title: "2", desc: "天", backgroundColor: .pink)
                        
                        LabelRichText(title: "4", desc: "文件", backgroundColor: .orange)
                        
                        LabelRichText(title: "1.2", desc: "小时", backgroundColor: .blue)
                    }
                    
                    //水平可滚动的Grid信息，对页面负载过大，可能导致切换重影
                    ScrollView(.horizontal,showsIndicators: false){
                        //LazyHGrid太重导致界面重绘.即使内部不进行渲染也会导致问题。CPU占用40%
//                        LazyHGrid(rows: rows,spacing: 2){
//                        //遍历所有数据源内容，从左侧竖直方向从上到下开始填充，超过行数之后另起一列进行排序
//                        //0 2 4
//                        //1 3 5
//                            ForEach(colum,id: \.self){ item in Rectangle().cornerRadius(1).frame(width: rectSize).foregroundColor(Color(hexString: "#F6F7F8"))}
//                        }
                    }
                    
                }.frame(maxWidth: .infinity).padding(10)
                    .background(.white)
                    .cornerRadius(10)
                
                
                //图片占位
                ZStack{
                    Rectangle().frame(height:80)
                        .foregroundColor(Color.black)
                        .cornerRadius(10)
                    
                    //设置的是在容器内最大宽度的视图为标准，水平位置设置。默认水平居中
                    VStack(alignment:.leading){
                        Text("智能总结，快速成功")
                            .bold()
                            .foregroundColor(.white)
                        
                        Spacer().frame(height: 15)
                        HStack{
                            Text("立即订阅")
                                .foregroundColor(.gray).font(.system(size: 12))
                        }
                    }.frame(maxWidth: .infinity,
                            //设置最大宽度，内部的视图水平如何对齐
                            alignment: .leading)
                    .padding(.horizontal, 15)
                    
                    
                    
                }
                
                
                FuncItemContainer{
                    NavigationLink(destination: WiFiView()) {
                        FuncItem(title: "转写记录", image: "icon_file_select")
                    }
                }
                
                FuncItemContainer{
                    NavigationLink(destination: WiFiView()) {
                        FuncItem(title: "PLAUD CLOUD", image: "icon_file_select", desc: "关闭")
                    }
                }
                FuncItemContainer{
                    NavigationLink(destination: WiFiView()) {
                        FuncItem(title: "我的PLAUD NOTE", image: "icon_file_select")
                    }
                }
                
                
                FuncItemContainer{
                    VStack(spacing:20){
                        NavigationLink(destination: WiFiView()) {
                            FuncItem(title: "帮助和反馈", image: "icon_file_select")
                        }
                        
                        NavigationLink(destination: AboutUsView()) {
                            FuncItem(title: "关于PLAUD", image: "icon_file_select", desc: "v2.0.10(109)")
                        }
                    }
                }
                
                ForEach(0...10,id:\.self){
                   item in Text("测试占位，滚动效果")
                }
            }
            
        }
        //设置底部边距，由于是TabView的底部高度也要计算在内，所以这边设置80
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
            .background(Color(hexString: "#F6F7F8"))
        // 默认NavigationView会添加一个顶部的显示区域，需要在子视图中进行设置来隐藏
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden()
        
    }
}

struct MineView_Previews: PreviewProvider {
    static var previews: some View {
        MineView()
    }
}

//标签富文本内容
struct LabelRichText:View{
    let title : String
    let desc : String
    
    let backgroundColor : Color
    
    var body: some View{
        HStack(alignment:.bottom,spacing: 2){
            Text(title)
                .bold()
                .font(.system(size: 16))
                .foregroundColor(.black)
                
            //通过offset实现底部对齐
            Text(desc)
                .font(.system(size: 11))
                .foregroundColor(.black)
                .offset(x:0,y:-2)
                
        }
        .padding(5)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(3)
    }
}

//承载的容器内容，传递需要同步的View
struct FuncItemContainer<Content : View> : View{
    //传递需要展示的布局内容
    var content : ()->Content
    var body: some View{
        content()
            .padding(EdgeInsets(top: 10, leading: 6, bottom: 10, trailing: 6))
            .background(.white)
            .cornerRadius(6)
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
            
            Spacer()
            
            //额外信息
            if !desc.isEmpty{
                
                Text(desc)
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            Spacer().frame(width: 15)
            //箭头
            Image("icon_arrow").resizable().frame(width:15, height: 15)
            
            
        }
    }
}


//设置在每一个item上，取消分割线的显示
//.listRowSeparator(.hidden)
