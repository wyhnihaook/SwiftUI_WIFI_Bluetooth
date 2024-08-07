//
//  DateUtil.swift
//  you
//
//  Created by 翁益亨 on 2024/7/11.
//

import Foundation

//Date转String格式
enum DateFormatContent : String{
    case YEAR_MONTH_DAY = "yyyy-MM-dd"
    case YEAR_MONTH_DAY_TIME = "yyyy-MM-dd HH:mm:ss"
}

//计算新的Date的标准.根据年、月、日推导
enum CalcNewDataType{
    case YEAR
    case MONTH
    case DAY
    case ALL
}

class DateUtil{
    static func convertToString(date:Date) -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    class func convertToString(date:Date, dateFormatContent: DateFormatContent) -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = dateFormatContent.rawValue
        return dateFormatter.string(from: date)
    }
    
    //MARK: - 字符串转化为Date类型
    class func convertToDate(dateString:String, dateFormatContent: DateFormatContent) -> Date?{
        if dateString.isEmpty{
            return nil
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = dateFormatContent.rawValue
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            return nil
        }
    }
    
    
    //MARK: - 根据天数来往计算新的日期。负数往前推，正数往后推
    class func calculateNewDate(type: CalcNewDataType, number: Int) -> Date?{
        let calendar = Calendar.current
        var components : DateComponents
        if type == .YEAR{
            components = DateComponents(year: number)
        }else if type == .MONTH{
            components = DateComponents(month: number)
        }else{
            components = DateComponents(day: number)
        }
        

        if let newDate = calendar.date(byAdding: components, to: Date()) {
            return newDate
        } else {
            return nil
        }
    }
    
}
