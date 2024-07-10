//
//  BarChartView.swift
//  you
//  根据DataPoint具像化的内容
//  Created by 翁益亨 on 2024/7/4.
//

import SwiftUI

struct BarChartView: View {
    let dataPoints: [DataPoint]

    var body: some View {
        HStack(alignment: .center) {
            ForEach(dataPoints) { point in
                VStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(point.color)
                        .frame(height: point.value * 50)
                    Text(point.label)
                }
            }
        }
    }
}
