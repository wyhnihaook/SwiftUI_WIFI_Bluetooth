//
//  AudioSummarize.swift
//  you
//  总结内容
//  Created by 翁益亨 on 2024/7/9.
//

import Foundation

struct AudioSummarize: Codable, Identifiable {
    var id = UUID()
    let title: String
    let time: String
    let duration : String
    let tag : String
    let source : String
    
    let content : [String]?
    
    let contactInfo : String?
}




extension AudioSummarize {
    static let info: AudioSummarize = AudioSummarize(
        title: "👏拍手叫好没有道理哈哈哈哈哈哈哈？？？", time: "2023-10-02 20:11:11", duration: "1m 52s", tag: "NOTE",source:"Greeting PLAUD Feedback", content: content, contactInfo: "hi@163.com"
    )
    
    static let content = ["时间啊时间啊啊科技大楼看见的😄","gaskdhaskdhkskajdkjasdjksahdka",
    "daslkjdlaksjdlasj大家看撒的哈看见的哈萨克红打卡时断开连接sadly","🎁没有了","时间啊时间啊啊科技大楼看见的😄","gaskdhaskdhkskajdkjasdjksahdka",
                          "daslkjdlaksjdlasj大家看撒的哈看见的哈萨克红打卡时断开连接sadly","🎁没有了","时间啊时间啊啊科技大楼看见的😄","gaskdhaskdhkskajdkjasdjksahdka",
                          "daslkjdlaksjdlasj大家看撒的哈看见的哈萨克红打卡时断开连接sadly","🎁没有了"]
}
