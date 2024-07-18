//
//  ApplePayView.swift
//  you
//  Apple Pay集成
//  Created by 翁益亨 on 2024/7/15.
//

import SwiftUI

struct ApplePayView: View {
    @EnvironmentObject var sharedData : SharedData

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
            
            
            Button("获取产品并去购买"){
                getOfferings()
            }
            .frame(width:300,height: 100)
            .background(Color(hexString: "#E9E9E9")).cornerRadius(10)
            
            Text("hello world".localized())

            Text("系统语言：\(String.getCurrentLanguage())")
            Text("应用内语言：\(sharedData.language)")

            HStack{
                Button("应用内切换成英文"){
                    sharedData.language = "en"
                }
                Button("应用内切换成中文"){
                    sharedData.language = "zh-Hans"
                }
            }
        }
        
        
    }
}

struct ApplePayView_Previews: PreviewProvider {
    static var previews: some View {
        ApplePayView()
    }
}
