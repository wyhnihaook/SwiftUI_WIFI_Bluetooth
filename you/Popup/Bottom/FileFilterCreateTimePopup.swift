//
//  FileFilterCreateTimePopup.swift
//  you
//  文件过滤 - 按照创建时间过滤
//  Created by 翁益亨 on 2024/8/6.
//

import SwiftUI

//CaseIterable ： 可以使用for in 循环遍历 allCases 数据
//时间选择器使用DatePicker结合弹窗功能实现
public enum FileFilterTime:String,CaseIterable{
    
    case Last7Days = "最近7天"
    case Last30Days = "最近30天"
    case Last3Months = "最近3个月"
    case Last6Months = "最近6个月"
    case LastYear = "最近1年"
    case ALL = "自注册以来"
    
}
//切记高度提前固定，不要使用内容自适应撑开
struct FileFilterCreateTimePopup : BottomPopup{
    
    
    //可选时间列表
    @State var timeList : [FileFilterTime] = [.Last7Days,.Last30Days,.Last3Months,.Last6Months,.LastYear,.ALL]
    
    //开始截止时间同步
    @State private var startTime = ""
    @State private var endTime = ""
    
    //时间的类型。枚举展示
    @State private var timeType = ""

    
    func createContent() -> some View {
        VStack(spacing:0){
            
            createTitle()
            
            Divider().background(Color(hexString: "#E9E9E9"))
            
            HStack{
                Text("开始于").frame(maxWidth:.infinity).onTapGesture {
                    
                    DateTimePickerPopup().showAndStack()
                }
                Text("-")
                Text("结束于").frame(maxWidth:.infinity)
            }.frame(height:44).background(.white).cornerRadius(4)
            
            
            createTimeCategory()
            
        }.padding(.horizontal, 15)
    }
}

extension FileFilterCreateTimePopup{
    func createTitle() -> some View{
        HStack(spacing:0){
            Text("创建时间").modifier(PopupTitleStyle()).frame(maxWidth:.infinity,alignment: .leading)
            
            //关闭按钮
            Image("icon_noise_reduction")
                .resizable()
                .frame(width: 22,height:22).onTapGesture {
                    dismiss()
                }
        }.frame(height: 44)
    }
    
    //MARK: - 开始于 结束于 时间选择器
    func createFilterTime() -> some View{
        HStack(spacing:0){
            
        }
    }
    
    //MARK: - 可选时间参数
    func createTimeCategory() -> some View{
        VStack(spacing:0){
            ForEach(timeList,id:\.rawValue){
                data in
                HStack{
                    Text(data.rawValue).frame(maxWidth:.infinity,alignment: .leading)
                    
                    if timeType == data.rawValue{
                        Text("check")
                    }
                    
                }
                //让空白区域点击也有效果的设置
                .contentShape(Rectangle())
                .onTapGesture {
                    timeType = data.rawValue
                }.frame(height: 40)
            }
        }
           
    }
}
