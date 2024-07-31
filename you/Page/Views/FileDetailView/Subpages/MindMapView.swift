//
//  MindMapView.swift
//  you
//  思维导图页面
//  Created by 翁益亨 on 2024/7/8.
//

import SwiftUI

struct MindMapView: View {
    
    @StateObject var audioMindMapModel = AudioMindMap()
    
    var body: some View {
        ZStack{
            if audioMindMapModel.textSizeSortList.count == audioMindMapModel.contentList.count && audioMindMapModel.pathHeightList.count == audioMindMapModel.contentList.count{
                VStack{
                    GeometryReader{
                        gp in //建立可以缩放的布局
                        ZoomableView(size: CGSize(width: gp.size.width, height: gp.size.height), min: 1.0, max: 3.0, showsIndicators: false) {
                            MindMapPathView(contentList: audioMindMapModel.contentList, title: audioMindMapModel.title, centerIndex: Int(audioMindMapModel.contentList.count/2),  keywordsTextSize: $audioMindMapModel.keywordsTextSize, textSizeList: $audioMindMapModel.textSizeSortList, pathHeightList: $audioMindMapModel.pathHeightList)
                        }
                    }
                }
                
            }else{
                //文本遍历堆叠展示数据
                GeometryReader{gp in
                    //关键字单独处理
                    TextCalcSingleSizeView(maxWidth: gp.size.width/2, text: audioMindMapModel.keywords, textSize:$audioMindMapModel.keywordsTextSize)
                    //建立可以缩放的布局
                    ForEach(0..<audioMindMapModel.contentList.count,id:\.self){index in
                        TextCalcSizeView(maxWidth: gp.size.width/2, text: audioMindMapModel.contentList[index], index: index,textSizeList:$audioMindMapModel.textSizeList)
                    }
                }
               
            }
            
            
        }.frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .background(.white)
            .padding(0)
//            .navigationBarTitle("", displayMode: .inline)
//            .navigationBarBackButtonHidden()
//            .navigationBarHidden(true)

            .onChange(of: audioMindMapModel.textSizeList.count) { newValue in
                audioMindMapModel.sortTextSizeList()
            }
    }
}

struct MindMapView_Previews: PreviewProvider {
    static var previews: some View {
        MindMapView()
    }
}
