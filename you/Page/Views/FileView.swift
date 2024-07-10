//
//  FileView.swift
//  you
//  文件页面
//  Created by 翁益亨 on 2024/6/28.
//

import SwiftUI

struct FileData{
    let title : String
    let date : String
    let time : String
}

struct FileView: View {
    
    var fileListData = [
        FileData(title: "How to Use", date: "2023-10-21 10:11:55", time: "1m 20s"),
        FileData(title: "How to Learn Tell Me Thanks One Two Three Four Five", date: "2023-10-21 10:11:55", time: "1m 20s")
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(alignment:.leading,spacing:10){
                Spacer().frame(height:10)
                
                //顶部文件数量描述
                HStack{
                    //图片
                    Image("icon_menu")
                        .resizable()
                        .frame(width: 30,height: 30)
                    //文本
                    Text("全部文件(\(fileListData.count))").font(.system(size: 24))
                        .bold()
                        .foregroundColor(.black)
                }
                Spacer().frame(height:2)
                
                //遍历数据源进行内容同步
                ForEach(fileListData,id: \.title) { item in
                    NavigationLink(destination: AudioWaveView()) {
                        FileItem(title: item.title, date: item.date, time: item.time)
                    }

                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
        .background(Color(hexString: "#F6F7F8"))
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
    }
}

struct FileView_Previews: PreviewProvider {
    static var previews: some View {
        FileView()
    }
}

//MARK: - 列表中显示的文件信息
struct FileItem : View{
    let title : String
    let date : String
    let time : String
    
    var body: some View{
        VStack(alignment:.leading,spacing: 7){
            Text(title)
                .bold()
                .foregroundColor(.black)
                .font(.system(size: 22))
            
            HStack(spacing:20){
                //日期
                Label{
                    Text(date)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hexString: "#dbdbdb"))
                }icon: {
                    Image("icon_calendar")
                        .resizable()
                        .frame(width:14, height: 14)
                }
                //时间内容
                
                Label{
                    Text(time)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hexString: "#dbdbdb"))
                }icon: {
                    Image("icon_clock")
                        .resizable()
                        .frame(width:14, height: 14)
                }
            }
            
            //底部标签Tag
            Text("NOTE")
                .frame(width: 40,height: 17)
                .background(Color(hexString: "#E9E9E9"))
                .cornerRadius(2)
                .font(.system(size: 10))
                .foregroundColor(.gray)
            
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
        .background(.white)
        .cornerRadius(10)
    }
}
