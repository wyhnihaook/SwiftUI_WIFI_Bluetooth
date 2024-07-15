//
//  ApplePayView.swift
//  you
//  Apple Pay集成
//  Created by 翁益亨 on 2024/7/15.
//

import SwiftUI

struct ApplePayView: View {
    
    @State var supportApplePay = false
    @State var supportBank = false

    var body: some View {
        VStack {
            Button("判断是否支持支付:\(supportApplePay.description)"){
                supportApplePay = ApplePayUtil.supportApplePay()
            }
            .frame(width:200,height: 50)
            .background(Color(hexString: "#E9E9E9")).cornerRadius(10)
            
            Button("判断是否添加储蓄/信用卡:\(supportBank.description)"){
                supportBank = ApplePayUtil.supportBank()
            }
            .frame(width:200,height: 50)
            .background(Color(hexString: "#E9E9E9")).cornerRadius(10)
            
            
        }.onAppear{
            let subtotalAmount = NSDecimalNumber.init(mantissa: 1275, exponent: -1, isNegative: false)

            print(NSDecimalNumber.init(mantissa: 200, exponent: -2, isNegative: true))
        }
        
        
    }
}

struct ApplePayView_Previews: PreviewProvider {
    static var previews: some View {
        ApplePayView()
    }
}
