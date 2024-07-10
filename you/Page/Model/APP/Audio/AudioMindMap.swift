//
//  AudioMindMap.swift
//  you
//
//  Created by 翁益亨 on 2024/7/10.
//

import SwiftUI
class AudioMindMap : ObservableObject{
    //文本尺寸信息同步
    var contentList = ["你是谁","不打算看得uhhuihiuhihhi见哈萨克的哈萨克知道","所dsakld的撒科技大厦来得及以呢","你是谁1kuiuhjgjgygyguygyuguyguyguygugugugugiuguigdshdjash11","不知道2打算来打卡时lkjdkadslaj间快点撒到22","所以打卡到家啊看撒打算看得见卡拉斯京的呢333"]
    var title = "的撒娇大赛好看的大数据库等哈看哈撒开就好"
    var keywords = "关键字：开车呢撒可能丹江口市快结束的哈萨克结婚的手机卡后打开"
    
    @Published var textSizeList : [MindMapTextSize] = []
    //排序完毕的数据
    @Published var textSizeSortList : [MindMapTextSize] = []

    //累加的高度
    @Published var pathHeightList : [Double] = []
    
    //关键字的尺寸获取
    @Published var keywordsTextSize : MindMapTextSize = MindMapTextSize(text: "", occupyWidth: 0.0, occupyHeight: 0.0)
    
    
    func sortTextSizeList(){
        if textSizeList.count == contentList.count{
            //要按照对应的顺序匹配顺序【将textSizeList的text按照contentList获取完毕】
            //排序完毕之后再进行填充
            for info in contentList{
                for item in textSizeList{
                    if item.text == info{
                        //当前两者内容匹配就添加到对应的sort列表中.继续轮训
                        textSizeSortList.append(item)
                        break
                    }
                }
            }
            
            
            //计算高度内容
            let centerIndex = Int(textSizeSortList.count/2)

            for index in 0..<centerIndex{
                var height = 0.0
                for inSideIndex in (index+1)...centerIndex{
                    //例如：角标为0的数据需要处理那么path的位置是1,2,3的字体高度 + 3 * 间距内容
                    //角标是1的情况，就是2，3两个角标
                    height += (textSizeSortList[inSideIndex].occupyHeight + 10)
                  
                }
                pathHeightList.append(height)
            }
         
            //中间Path的高度
            pathHeightList.append(0)
            
            for index in (centerIndex + 1)..<contentList.count{
                var height = 0.0

                for inSideIndex in (centerIndex + 1)...index{
                    //例如：角标为0的数据需要处理那么path的位置是1,2,3的字体高度 + 3 * 间距内容
                    //角标是1的情况，就是2，3两个角标 。这里的10同步MindMapPathView中的数据
                    height += (textSizeSortList[inSideIndex].occupyHeight + 10)
                }
                pathHeightList.append(height)

            }
            
        }
    }
}
