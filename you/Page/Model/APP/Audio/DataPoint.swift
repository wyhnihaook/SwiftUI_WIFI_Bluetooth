//
//  DataPoint.swift
//  you
//  垂直条形显示一组数据点
//  Created by 翁益亨 on 2024/7/4.
//

import SwiftUI

struct DataPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let color: Color
}
