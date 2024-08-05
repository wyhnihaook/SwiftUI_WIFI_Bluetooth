//
//  Color+Ext.swift
//  you
//  注意：上面Color调用cgColor只支持iOS14之后，iOS13会报错'cgColor' is only available in iOS 14.0 or newer。
//  Created by 翁益亨 on 2024/7/2.
//

import Foundation
import SwiftUI

private extension Color {
    init(hex: UInt) { self.init(.sRGB, red: Double((hex >> 16) & 0xff) / 255, green: Double((hex >> 08) & 0xff) / 255, blue: Double((hex >> 00) & 0xff) / 255, opacity: 1) }
}

 
extension Color {
    static let primary: Color = .init(hex: 0x388091)
    static let secondary: Color = .init(hex: 0xE66460)
    static let onBackgroundPrimary: Color = .init(hex: 0x252525)
    static let onBackgroundSecondary: Color = .init(hex: 0x6F7278)
    static let onBackgroundTertiary: Color = .init(hex: 0xEEF1F7)
    
    //主题色
    static let moon: Color = .init(hex: 0x000000)
    static let sun: Color = .init(hex: 0xFFFFFF)
    
    //颜色内容
    static let color_f6f7f9: Color = .init(hex: 0xF6F7F9)
    static let color_d7e8f0: Color = .init(hex: 0xd7e8f0)

    

    
    var gradient: AngularGradient {
        return AngularGradient(gradient: Gradient(colors: [self]),center: .center)
    }
    public init?(hexString: String, alpha: CGFloat? = nil) {
        if let rgbaArr = hexString.RGBAArr(alpha), rgbaArr.count == 4 {
            self.init(red: rgbaArr[0], green: rgbaArr[1], blue: rgbaArr[2], opacity: rgbaArr[3])
        } else {
            return nil
        }
    }
    
    public init?(r: Double, g: Double, b: Double) {
        self.init(red: r, green: g, blue: b)
    }
    
    public init?(r: Double, g: Double, b: Double, a: Double = 1) {
        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    /// Color转十六进制颜色字符串，包含alpha。
    public func RGBAHex() -> String? {
        let components = self.cgColor?.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        let a: CGFloat = components?[3] ?? 0.0
        let hexString = String(format: "#%02lX%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)), lroundf(Float(a * 255)))
        return hexString
    }
    
    /// Color转十六进制颜色字符串，忽略alpha。
    public func RGBHex() -> String? {
        let components = self.cgColor?.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        let hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
    
}
 
extension String {
    
    /// 十六进制颜色转RGBA数组
    /// 若priorityAlpha有传值，就算十六进制字符串中带有alpha也优先使用priorityAlpha。
    func RGBAArr(_ priorityAlpha: CGFloat? = nil) -> [CGFloat]? {
        let hex = self
        var formatted = hex.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        guard formatted.count == 6 || formatted.count == 8 else { return nil }
        
        var r: Int = 0
        var g: Int = 0
        var b: Int = 0
        var a: Int = 255
        let hexStr = formatted as NSString
        let rHex = hexStr.substring(with: NSRange(location: 0, length: 2))
        let gHex = hexStr.substring(with: NSRange(location: 2, length: 2))
        let bHex = hexStr.substring(with: NSRange(location: 4, length: 2))
        guard let rTen = Int(rHex, radix: 16), let gTen = Int(gHex, radix: 16), let bTen = Int(bHex, radix: 16)  else {
            return nil
        }
        r = rTen
        g = gTen
        b = bTen
        if formatted.count == 8 {
            let aHex = hexStr.substring(with: NSRange(location: 6, length: 2))
            guard let aTen = Int(aHex, radix: 16) else { return nil }
            a = aTen
        }
 
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        var alpha = CGFloat(a) / 255.0
        if let priorityAlpha = priorityAlpha {
            alpha = priorityAlpha
        }
        return [red, green, blue, alpha]
    }
    
}
