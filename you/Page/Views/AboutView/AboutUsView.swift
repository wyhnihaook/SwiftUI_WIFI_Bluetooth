//
//  AboutUsView.swift
//  you
//  关于我们
//  Created by 翁益亨 on 2024/7/3.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        NavigationBody(title: "关于PLAUD") {
            
        } content: {
            ScrollView(showsIndicators: false){
                VStack{
                    Spacer().frame(height: 30)
                    //标签
                    Group{
                        Image("icon_head_default")
                            .resizable()
                            .frame(width: 80,height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Text("PLAUD").font(.system(size: 28))
                            .bold()
                            .foregroundColor(.black).padding(.vertical,5)
                        
                        Text("v2.0.11(113)").font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                    
                    Spacer().frame(height:30)
                    
                    Group{
                        Text("官方社交媒体").frame(maxWidth:.infinity,alignment: .leading).font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        AboutFuncItemContainer{
                            //内容信息
                            VStack{
                                AboutFuncItem(title: "官方网站", image: "icon_file_select",titleColor: .blue)
                                AboutFuncItem(title: "在 X 上关注我们", image: "icon_file_select",titleColor: .blue)
                                AboutFuncItem(title: "在 Facebook 上关注我们", image: "icon_file_select",titleColor: .blue)
                                AboutFuncItem(title: "在 Instagram 上关注我们", image: "icon_file_select",titleColor: .blue)
                                AboutFuncItem(title: "在Tiktok上关注我们", image: "icon_file_select",isLast: true,titleColor: .blue).onTapGesture {
                                    print("关注tiktok")
                                }
                            }
                        }
                        
                    }
                    Spacer().frame(height: 20)
                    AboutFuncItemContainer{
                        AboutFuncItem(title: "评分与反馈", image: "icon_file_select",canOperate: true,isLast: true)
                    }
                    Spacer().frame(height: 30)
                    Group{
                        Text("法规").frame(maxWidth:.infinity,alignment: .leading).font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        AboutFuncItemContainer{
                            //内容信息
                            VStack{
                                AboutFuncItem(title: "用户协议", image: "icon_file_select",canOperate: true)
                         
                               
                                AboutFuncItem(title: "隐私政策", image: "icon_file_select",canOperate: true,isLast: true)
                            }
                        }
                        
                    }
                    
                    Spacer().frame(height:100)
                   
                }
            }.padding(.horizontal,30)
                .background(Color(hexString: "#F6F7F9"))
        }

    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}

//承载的容器内容，传递需要同步的View
struct AboutFuncItemContainer<Content : View> : View{
    //传递需要展示的布局内容
    var content : ()->Content
    var body: some View{
        content()
            .padding(.vertical,10)
            .background(.white)
            .cornerRadius(6)
    }
}


//图片 + 文字内容
struct AboutFuncItem:View{
    let title : String
    let image : String
    let canOperate : Bool
    let isLast : Bool
    
    //需要定向修改的文本颜色
    let titleColor : Color
    
    init(title: String, image: String, canOperate: Bool = false, isLast : Bool = false, titleColor:Color = .black) {
        self.title = title
        self.image = image
        self.canOperate = canOperate
        self.isLast = isLast
        self.titleColor = titleColor
    }
    
    var body: some View{
        VStack{
            HStack{
                Spacer().frame(width: 16)
                Image(image)
                    .resizable()
                    .frame(width: 28, height: 28)
                
                Spacer().frame(width: 10)
                
                Text(title)
                    .foregroundColor(titleColor)
                    .font(.system(size: 16))
                
                Spacer()
                
                
                //箭头
                if canOperate{
                    Image("icon_arrow").resizable().frame(width:10, height: 10)
                    
                    Spacer().frame(width: 10)
                }
                
            }.frame(height: 30)
            
            if !isLast{
                Divider().background(Color(hexString: "#E9E9E9"))
            }
           
            
        }.background(Color.white)
    }
}
