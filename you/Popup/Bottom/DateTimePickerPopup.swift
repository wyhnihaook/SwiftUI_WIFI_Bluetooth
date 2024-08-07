//
//  DateTimePickerPopup.swift
//  you
//  承载的系统选择器弹窗
//  参考：https://blog.csdn.net/guoyongming925/article/details/139106767
//  Created by 翁益亨 on 2024/8/6.
//

import SwiftUI

struct DateTimePickerPopup:BottomPopup{
    
    //初始化让DatePicker在页面显示完成之后再适配高度。避免第一次点击页面内容时造成抖动【高度变化导致】
    @State private var initDatePicker = false
    
    @State private var selectDate = Date()
    
    private var initDate : Date
    
    private var callback : (Date)->Void
    
    var dateFormatter : DateFormatter{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }
    
    var startDate = Calendar.current.date(from: DateComponents(year:2020,month:1,day:1)) ?? Date()
    
    var endDate = Date()
    
    init(initDate: Date?, callback: @escaping (Date) -> Void){
        self.initDate = initDate ?? Date()
        self.callback = callback
    }
    
    func createContent() -> some View {
        //displayedComponents: .date 只显示部分日期
        VStack{
            if initDatePicker{
                DatePicker("选择时间", selection: $selectDate, in : startDate...endDate, displayedComponents: .date).padding()
                    //隐藏标题
                    .labelsHidden()
                    //设置展示的样式
                    .datePickerStyle(.graphical)
                    //内部高度会变化 - 需要等待页面完全显示后再出实话
            }
            
            Spacer()

            Button{
                callback(selectDate)
                dismiss()
            }label:{
                Text("确定")
            }
            
            Spacer().frame(height:20)
            
        }.frame(height:450).onAppear{
            
            selectDate = initDate
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01){
                initDatePicker = true
            }
        }
    }
    
}
