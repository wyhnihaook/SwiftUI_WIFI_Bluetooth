//
//  AudioConvertTextView.swift
//  you
//  语音转文本操作
//  Created by 翁益亨 on 2024/7/8.
//

import SwiftUI

struct AudioConvertTextView: View {
    @State private var selection = FileDetailTabBar.transfer.rawValue

    
    var body: some View {
        GeometryReader{ gp in
            
            //gp.safeAreaInsets.bottom 底部安全距离掌握
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
                    .background(.gray)
                    .cornerRadius(6)
                }.padding(.horizontal,10)
                
                
                TabView(selection: $selection) {
                    
                    TransferView()
                        .tag(FileDetailTabBar.transfer.rawValue)
                        
                    SummarizeView()
                        .tag(FileDetailTabBar.summarize.rawValue)
                    
                    MindMapView()
                        .tag(FileDetailTabBar.mindMap.rawValue)
                    
                }.background(Color.clear)
                
                
            }
            
           
          
        }
    }
}

struct AudioConvertTextView_Previews: PreviewProvider {
    static var previews: some View {
        AudioConvertTextView()
    }
}

