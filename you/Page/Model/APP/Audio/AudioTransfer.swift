//
//  AudioTransfer.swift
//  you
//  音频转写数据
//  Created by 翁益亨 on 2024/7/8.
//

import Foundation
import SwiftUI

struct AudioTransfer: Codable, Identifiable {
    var id = UUID()
    let desc: String
    let time: String
}


//转写Item。显示的是时间+对应的文本内容
struct TransferDataView:View{
    
    let audioTransfer : AudioTransfer
    
    var body: some View{
        HStack(alignment:.top){
            Circle()
                .fill(.gray)
                .frame(width:7,height:7)
                .offset(x:0,y:4)
            
            VStack(alignment:.leading){
                Text(audioTransfer.time)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                Spacer().frame(height:10)
                
                Text(audioTransfer.desc).font(.system(size: 14))
                    .foregroundColor(.black)
                

            }
              
           
        } .padding(.horizontal, 10)
        
        
       
    }
}

extension AudioTransfer {
    static let all: [AudioTransfer] = [
        swiftui,
        goddess,
        pm,
        landlord,
        wang,
        princess,
        foodie,
        nameless,
        chives,
        me,
    ]
    
    static let swiftui = AudioTransfer(
        desc: "SwiftUI is a modern way to declare user interfaces for any Apple platform. Create beautiful, dynamic apps faster than ever before.",
        time: "18:14"
    )
    
    static let goddess = AudioTransfer(
        desc: "你在干嘛？怎么不说话🥺",
        time: "18:05"
    )
    
    static let pm = AudioTransfer(
        desc: "今天开会提到的需求，下班之前弄完！",
        time: "18:01"
    )
    
    static let landlord = AudioTransfer(
        desc: "兄弟，下个月的房租该交了",
        time: "16:23"
    )
    
    static let wang = AudioTransfer(
        desc: "看到了",
        time: "昨天"
    )
    
    static let princess = AudioTransfer(
        desc: "[视频通话]",
        time: "星期二"
    )
    
    static let foodie = AudioTransfer(
        desc: "晚上去撸串不？",
        time: "2019/11/12"
    )
    
    static let nameless = AudioTransfer(
        desc: "[视频]",
        time: "2019/10/28"
    )
    
    static let chives = AudioTransfer(
        desc: "在吗？",
        time: "2019/08/03"
    )
    
    static let me = AudioTransfer(
        desc: "SwiftUI 写起来爽么？",
        time: "2019/07/14"
    )
}
