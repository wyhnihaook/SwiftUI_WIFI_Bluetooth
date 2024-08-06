//
//  DateTimePickerPopup.swift
//  you
//  承载的系统选择器弹窗
//  参考：https://blog.csdn.net/guoyongming925/article/details/139106767
//  Created by 翁益亨 on 2024/8/6.
//

import SwiftUI
struct DateTimePickerPopup:BottomPopup{
    
    @State private var selectDate = Date()
    
    var dateFormatter : DateFormatter{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }
    
    var startDate = Calendar.current.date(from: DateComponents(year:2020,month:1,day:1)) ?? Date()
    
    var endDate = Date()
    
    func createContent() -> some View {
        //displayedComponents: .date 只显示部分日期
        VStack{
            DatePicker("选择时间", selection: $selectDate, in : startDate...endDate, displayedComponents: .date).padding()
                //隐藏标题
                .labelsHidden()
                //设置展示的样式
                .datePickerStyle(.graphical)
//                .frame(height:300)
                
            Button{
                
            }label:{
                Text("确定")
            }
        }.frame(height:500)
    }
    
}
