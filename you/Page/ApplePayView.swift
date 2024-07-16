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
    
    var applePayUtil = ApplePayUtil()

    var body: some View {
        VStack {
            Button("点我获取\n是否支持支付:\(supportApplePay.description) \n 是否已经添加储蓄/信用卡:\(supportBank.description)"){
              (supportApplePay,supportBank) = ApplePayUtil.applePayStatus()
            }
            .frame(width:300,height: 100)
            .background(Color(hexString: "#E9E9E9")).cornerRadius(10)
            
            Button("去支付"){
                applePayUtil.createPayRequest()
            }
            .frame(width:300,height: 100)
            .background(Color(hexString: "#E9E9E9")).cornerRadius(10)
            
        }.onAppear{
            
        }
        
        
    }
}

struct ApplePayView_Previews: PreviewProvider {
    static var previews: some View {
        ApplePayView()
    }
}
