//
//  AnimationType.swift of PopupView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//
//  Copyright ©2023 Mijick. Licensed under MIT License.


import SwiftUI

public enum AnimationType { case spring, linear, easeInOut }
extension AnimationType {
    var entry: Animation { switch self {
        //.spring 弹性动画效果 存在默认值spring(response: Double = 0.55, dampingFraction: Double = 0.825, blendDuration: Double = 0)
//response: 这个值决定了动画开始的速度。越大整个过渡越慢，越小过渡越快
//    dampingFraction: 这个值决定了动画结束时的阻尼程度。较小的值会导致更多的摆动，而较大的值则会导致动画更快地平稳下来。
//    blendDuration: 这个值决定了动画开始前的延迟时间。设置为 0 表示没有延迟。
    case .spring: return .spring(response: 0.2, dampingFraction: 0.825, blendDuration: 0.1)
        case .linear: return .linear(duration: 0.4)
        case .easeInOut: return .easeInOut(duration: 0.4)
    }}
    var removal: Animation { switch self {
//        case .spring: return .spring(duration: 0.32, bounce: 0, blendDuration: 0.1)
    case .spring: return .spring(response: 0.2, dampingFraction: 0.825, blendDuration: 0.1)
        case .linear: return .linear(duration: 0.3)
        case .easeInOut: return .easeInOut(duration: 0.3)
    }}
    var dragGesture: Animation { .linear(duration: 0.05) }
}
