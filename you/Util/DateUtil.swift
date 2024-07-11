//
//  DateUtil.swift
//  you
//
//  Created by 翁益亨 on 2024/7/11.
//

import Foundation
class DateUtil{
    static func convertToString(date:Date) -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
