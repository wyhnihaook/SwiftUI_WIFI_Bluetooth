//
//  AudioConvertTextView.swift
//  you
//  语音转文本操作
//  Created by 翁益亨 on 2024/7/8.
//

import SwiftUI

struct AudioConvertTextView: View {
    @State private var selection = FileDetailTabBar.summarize.rawValue

    //加载完毕后内容就不会变化，直接传递对应的数据源
    @Binding var fileOnCloudDetailData : FileOnCloudDetailData?
    
    var body: some View {
//        GeometryReader{ gp in
//
//            //gp.safeAreaInsets.bottom 底部安全距离掌握
//
//
//
//
//        }.onAppear{
//
//        }
        
        VStack{
            
            Group{
                HStack(alignment:.bottom){
                    FileDetailTabBarView(item: .transfer, isSelected: selection == FileDetailTabBar.transfer.rawValue)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            selection = FileDetailTabBar.transfer.rawValue
                        }
                    FileDetailTabBarView(item: .summarize, isSelected: selection == FileDetailTabBar.summarize.rawValue)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            selection = FileDetailTabBar.summarize.rawValue
                        }
                    FileDetailTabBarView(item: .mindMap, isSelected: selection == FileDetailTabBar.mindMap.rawValue)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            selection = FileDetailTabBar.mindMap.rawValue
                        }
                }
                .background(Color(hexString:"#F6F7F9"))
                .cornerRadius(6)
            }.padding(.horizontal,10)
            
            
            TabView(selection: $selection) {
                
                TransferView(transferList: fileOnCloudDetailData?.transferList)
                    .tag(FileDetailTabBar.transfer.rawValue)

                SummarizeView(fileOnCloudDetailData: fileOnCloudDetailData!)
                    .tag(FileDetailTabBar.summarize.rawValue)

                MindMapView()
                    .tag(FileDetailTabBar.mindMap.rawValue)
                
            }
//                .navigationBarTitle("", displayMode: .inline)
//                .navigationBarBackButtonHidden()
//                .navigationBarHidden(true)
            
            //三个页面切换的时候影响顶部的标题栏，目前通过开启水平滚动来规避这个问题
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .tabViewStyle(DefaultTabViewStyle())
            .background(Color.clear)

            
            
        }
    }
}

//struct AudioConvertTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioConvertTextView()
//    }
//}

