//
//  FileDatailView.swift
//  you
//  文件详情
//  Created by 翁益亨 on 2024/7/4.
//

import SwiftUI

struct FileDetailView : View {
    @State private var dataPoints = [
            DataPoint(label: "1", value: 3, color: .red),
            DataPoint(label: "2", value: 5, color: .blue),
            DataPoint(label: "3", value: 2, color: .red),
            DataPoint(label: "4", value: 4, color: .blue),
            DataPoint(label: "1", value: 3, color: .red),
            DataPoint(label: "2", value: 5, color: .blue),
            DataPoint(label: "3", value: 2, color: .red),
            DataPoint(label: "4", value: 4, color: .blue),
        ]

    
    var body: some View{
        VStack{
            AudioWaveView()
            
            //TabBar显示标签内容
        }
        .navigationBarHidden(true)
        .background(Color(hexString: "#E9E9E9"))
    }
}

struct FileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FileDetailView()
    }
}


extension FileDetailView: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Labels",
            categoryOrder: dataPoints.map(\.label)
        )

        let min = dataPoints.map(\.value).min() ?? 0.0
        let max = dataPoints.map(\.value).max() ?? 0.0

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Values",
            range: min...max,
            gridlinePositions: []
        ) { value in "\(value) points" }

        let series = AXDataSeriesDescriptor(
            name: "",
            isContinuous: false,
            dataPoints: dataPoints.map {
                .init(x: $0.label, y: $0.value)
            }
        )

        return AXChartDescriptor(
            title: "Chart representing some data",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}


