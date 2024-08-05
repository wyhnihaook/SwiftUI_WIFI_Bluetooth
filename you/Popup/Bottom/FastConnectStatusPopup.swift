//
//  FastConnectStatusPopup.swift
//  you
//  快速连接 连接状态显示
//  Created by 翁益亨 on 2024/8/5.
//

import SwiftUI

//每一个状态显示管理
struct FastConnectStatusData:Identifiable{
    var id = UUID()
    
    //本地的图片显示
    let imageName : String
    
    //状态描述
    let statusDesc : String
    
    //状态 0:未启动，1:连接中 2:连接成功 3:连接失败
    var status : Int
}

struct FastConnectStatusPopup : BottomPopup{
    
    //一直显示loading状态标识
    @State var showLoadingIndicator = true
    
    @State var connectList : [FastConnectStatusData] = [.init(imageName: "icon_rect_unselect", statusDesc: "开启PLAUD NOTE热点", status: 1),.init(imageName: "icon_rect_unselect", statusDesc: "搜索PLAUD NOTE热点", status: 0),.init(imageName: "icon_rect_unselect", statusDesc: "连接到PLAUD NOTE的热点", status: 0)]
    
    
    func createContent() -> some View {
        VStack(spacing:0){
            Text("连接到PLAUD NOTE 的热点").bold().modifier(PopupTitleStyle()).padding(.top, 20).padding(.bottom, 30)
            
            ForEach(connectList.indices,id:\.self){ index in
                createStatusContent(connectList[index], index)
            }
          
            Text("PLAUD NOTE 蓝灯闪烁").font(.system(size: 14)).foregroundColor(.gray).frame(maxWidth: .infinity,alignment: .leading).padding(.leading,33).padding(.top, 20)
            
        }.padding(15).onAppear{
            //开始进行连接改变状态
            print("connecting")
            
            //修改流程显示【根据业务流程来触发状态流转】
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                connectList[0].status = 2
                connectList[1].status = 1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    FastTransmissionProgressPopup().showAndReplace()
                }
            }
            
            
        }
    }
}

extension FastConnectStatusPopup{
    func createStatusContent(_ data : FastConnectStatusData, _ index:Int) -> some View {
        VStack(alignment:.leading,spacing:0){
            HStack{
                Image(data.imageName).resizable().frame(width: 22,height: 22)
                
                Text(data.statusDesc).font(.system(size: 14)).bold().foregroundColor(.black).padding(.leading, 2)
                
                Spacer()
                
                //状态显示
                createStatus(data.status)
                
            }.frame(height: 40).frame(maxWidth: .infinity)
            
            
            if index != connectList.count - 1{
                //中间添加过渡内容
                ForEach(0...6,id:\.self){data in
                    Circle().foregroundColor(.black).frame(width:2,height: 2).padding(.vertical,2).padding(.leading, 10)
                }
            }
        }
    }
    
    
    func createStatus(_ status : Int) -> some View{
        VStack{
            switch(status){
                case 1:
                    ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .scalingDots())
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
                case 2:
                    Image("icon_rect_unselect").resizable().frame(width: 22,height: 22)
                case 3:
                    Image("icon_rect_unselect").resizable().frame(width: 22,height: 22)
                default:
                    //SwiftUI提供了EmptyView作为占位内容
                    EmptyView()
            }
        }
        //设置公共的尺寸占位，为了让EmptyView也占位
        .frame(width: 40)
    }
    
}
