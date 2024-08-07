//
//  FileFilterCreateTimePopup.swift
//  you
//  文件过滤 - 按照创建时间过滤
//  Created by 翁益亨 on 2024/8/6.
//

import SwiftUI

struct FileFilterTimeData{
    let timeType : CalcNewDataType
    let numbers : Int
}

//CaseIterable ： 可以使用for in 循环遍历 allCases 数据
//时间选择器使用DatePicker结合弹窗功能实现
public enum FileFilterTime:String,CaseIterable{
    
    case Last7Days = "最近7天"
    case Last30Days = "最近30天"
    case Last3Months = "最近3个月"
    case Last6Months = "最近6个月"
    case LastYear = "最近1年"
    case ALL = "自注册以来"
    
    func data()->FileFilterTimeData{
        switch self{
        case .Last7Days:
            return .init(timeType: .DAY, numbers: -7)
        case .Last30Days:
            return .init(timeType: .DAY, numbers: -30)
        case .Last3Months:
            return .init(timeType: .MONTH, numbers: -3)
        case .Last6Months:
            return .init(timeType: .MONTH, numbers: -6)
        case .LastYear:
            return .init(timeType: .YEAR, numbers: -1)
        default:
            //注册以来全部展示
            return .init(timeType: .ALL, numbers: 0)
        }
    }
    
}
//切记高度提前固定，不要使用内容自适应撑开
struct FileFilterCreateTimePopup : BottomPopup{
    //需要同步的时间内容通过@Binding数据绑定点击确定后同步
    
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
            
            Spacer.height(10)
            
            HStack{
                Text(startTime.isEmpty ? "开始于" : startTime).frame(maxWidth:.infinity).onTapGesture {
                    //当前同步到时间数据
                    DateTimePickerPopup(initDate: DateUtil.convertToDate(dateString: startTime, dateFormatContent: DateFormatContent.YEAR_MONTH_DAY), callback: { date in
                        startTime = DateUtil.convertToString(date: date,dateFormatContent: DateFormatContent.YEAR_MONTH_DAY)
                    }).showAndStack()
                }
                Text("-")
                Text(endTime.isEmpty ? "结束于" : endTime).frame(maxWidth:.infinity).onTapGesture {
                    DateTimePickerPopup(initDate: DateUtil.convertToDate(dateString: endTime, dateFormatContent: DateFormatContent.YEAR_MONTH_DAY), callback: { date in
                        endTime = DateUtil.convertToString(date: date,dateFormatContent: DateFormatContent.YEAR_MONTH_DAY)
                    }).showAndStack()
                }
            }.frame(height:44).background(.white).cornerRadius(4)
            
            Spacer.height(10)
            
            createTimeCategory()
            
            Spacer.height(10)
            
            Button{
                //筛选结果
                dismiss()
            }label:{
                Text("确认").foregroundColor(.white).frame(maxWidth:.infinity).frame(height:44).background(.black).cornerRadius(10)
            }
            
        }.padding(.horizontal, 15).background(Color.color_f6f7f9)
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
                VStack(spacing:0){
                    HStack{
                        Text(data.rawValue).frame(maxWidth:.infinity,alignment: .leading).padding(.leading, 15)
                        
                        if timeType == data.rawValue{
                            Text("check")
                        }
                        
                    }
                    //让空白区域点击也有效果的设置
                    .contentShape(Rectangle())
                    .onTapGesture {
                        timeType = data.rawValue
                        let timeData = data.data()
                        if timeData.timeType != .ALL{
                            //开始和结束时间展示同步
                            if let newDate  = DateUtil.calculateNewDate(type: timeData.timeType, number: timeData.numbers){
                                startTime = DateUtil.convertToString(date: newDate,dateFormatContent: DateFormatContent.YEAR_MONTH_DAY)
                            }
                          
                            //结束时间都由当前时间来定
                            endTime = DateUtil.convertToString(date: Date(),dateFormatContent: DateFormatContent.YEAR_MONTH_DAY)
                        }else{
                            startTime = ""
                            endTime = ""
                        }
                        
                    }.frame(height: 40)
                    
                    Divider().background(Color(hexString: "#E9E9E9")).padding(.leading,15)

                }
            }
        }.frame(height:41*6 + 5).padding(.bottom, 5).background(.white).cornerRadius(10)
           
    }
}
