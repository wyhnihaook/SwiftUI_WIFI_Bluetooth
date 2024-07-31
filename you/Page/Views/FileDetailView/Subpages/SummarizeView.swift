//
//  SummarizeView.swift
//  you
//  总结页面
//  Created by 翁益亨 on 2024/7/8.
//

import SwiftUI

struct SummarizeView: View {
//    @State private var audioSummarize: AudioSummarize?
    
    //详情信息
    var fileOnCloudDetailData : FileOnCloudDetailData

    var body: some View {
        ScrollView{
            VStack(alignment:.leading){
                Text(fileOnCloudDetailData.title)
                    .bold()
                    .foregroundColor(.black)
                    .font(.system(size: 22))
                
                HStack(spacing:20){
                    //底部标签Tag
                    if fileOnCloudDetailData.labels != nil{
                        ForEach(fileOnCloudDetailData.labels!,id:\.labelId) { label in
                            Text(label.labelName)
                                .foregroundColor(Color(hexString: label.labelColor))
                                .frame(width: 40,height: 17)
                                .background(Color(hexString: "#E9E9E9"))
                                .cornerRadius(2)
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    //日期
                    Label{
                        Text(fileOnCloudDetailData.createdTime)
                            .font(.system(size: 11))
                            .foregroundColor(Color(hexString: "#dbdbdb"))
                    }icon: {
                        Image("icon_calendar")
                            .resizable()
                            .frame(width:14, height: 14)
                    }
                    //时间内容
                    Label{
                        Text(fileOnCloudDetailData.duration)
                            .font(.system(size: 11))
                            .foregroundColor(Color(hexString: "#dbdbdb"))
                    }icon: {
                        Image("icon_clock")
                            .resizable()
                            .frame(width:14, height: 14)
                    }
                }
                
                Divider().background(Color(hexString: "#E9E9E9")).padding(.vertical,10)
                
                Text("来源").background(Color(hexString: "#F6F7F9"))
                    .foregroundColor(.gray)
                    .font(.system(size: 16)).padding(.top, 10).padding(.bottom,40)
                
                if fileOnCloudDetailData.conclusion.isNotEmpty{
                    ForEach(fileOnCloudDetailData.conclusion.split(separator: "\n"),id:\.self){contentItem in
                        HStack(spacing:10){
                            Circle()
                                .foregroundColor(.black)
                                .frame(width: 6,height: 6)
                            
                            Text(contentItem).font(.system(size: 16)).foregroundColor(.black)
                        }
                    }
                }
                
                if "联系方式" != nil{
                    //存在联系我们
                    HStack{
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(width: 3,height:20)
                        
                        Spacer().frame(width: 6)
                        Text("Contact us:")
                        Text("联系方式").underline(true,color:.red)

                    }.padding(.top,20)
                }
                
                //表示点击好和差
                HStack(spacing:20){
                    Spacer()
                    Label{
                        Text("好")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hexString: "#dbdbdb"))
                    }icon: {
                        Image("icon_calendar")
                            .resizable()
                            .frame(width:14, height: 14)
                    }.frame(width:100,height:30)
                        .background(.pink)
                        .cornerRadius(10)
                    
                    Label{
                        Text("差")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hexString: "#dbdbdb"))
                    }icon: {
                        Image("icon_calendar")
                            .resizable()
                            .frame(width:14, height: 14)
                    }.frame(width:100,height:30)
                        .background(.gray)
                        .cornerRadius(10)
                    
                    Spacer()
                }.padding(.vertical,40)
                
                
            }.padding(.horizontal, 15)
            
        } .background(.white)
            .padding(0)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
//            .navigationBarTitle("", displayMode: .inline)
//            .navigationBarBackButtonHidden()
//            .navigationBarHidden(true)
            .onAppear(perform: load)
    }
    
    func load() {
//        if audioSummarize == nil {
//            audioSummarize = AudioSummarize.info
//        }
    }
}

//struct SummarizeView_Previews: PreviewProvider {
//    static var previews: some View {
//        SummarizeView()
//    }
//}
