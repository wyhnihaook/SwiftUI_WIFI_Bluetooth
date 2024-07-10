//
//  MinimapView.swift
//  you
//  存在进度的波形图。start是开始的位置，length是过渡的位置【这里的length范围是0-1标识对应的进度】
//  手势触摸同步结果内容【用于定位音频播放内容】，最右侧有个红线开始播放
//  Created by 翁益亨 on 2024/7/5.
//


import AVFoundation
import SwiftUI
import Waveform

struct MinimapView: View {
    @Binding var start: Double
    var length: Double

    @Binding var indicatorSize : Double

    var body: some View {
        GeometryReader { gp in
            Rectangle()
                .frame(width: length * gp.size.width)
                .offset(x: start * gp.size.width)
                .opacity(0.3)
               


            //标识当前的进度位置，一直处于length所代表的结尾处
            RoundedRectangle(cornerRadius: indicatorSize)
                .foregroundColor(.red)
                .frame(width: 1).opacity(1)
                .offset(x: (length) * gp.size.width)
                .padding(0)
            

        }
    }
}


func clamp(_ x: Double, _ inf: Double, _ sup: Double) -> Double {
    max(min(x, sup), inf)
}

