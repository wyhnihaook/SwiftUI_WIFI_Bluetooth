//
//  ApplePayUtil.swift
//  you
//  苹果的Apple Pay 工具类
//  Created by 翁益亨 on 2024/7/15.
//

import Foundation
//用户绑定的银行卡信息【包含Apple Pay展示银行卡信息控件】
import PassKit
//用户联系信息相关
import AddressBook

class ApplePayUtil {
    
    //判断是否支持Apple Pay 支付 【这里涵盖了支付宝/微信/银行卡信息的结果，只要支持就是允许网络付款】
    class func supportApplePay() -> Bool{
        return PKPaymentAuthorizationViewController.canMakePayments()
    }
    
    
    //判断是否添加了支付的储蓄卡/信用卡【注意：只针对储蓄卡/信用卡】
    class func supportBank() -> Bool{
        return PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [.amex,.masterCard,.visa,.chinaUnionPay])
    }
    
    
    //创建支付请求
    class func createPayRequest(){
        let payRequest = PKPaymentRequest()
        ///设置币种、国家码以及之前设置的merchant ID标识符 【merchant.com.zai.you】
        ///国家代码
        payRequest.countryCode = "CN"
        ///RMB的币种代码
        payRequest.currencyCode = "CNY"
        payRequest.merchantIdentifier = "merchant.com.zai.you"
        ///支持的支付方式
        payRequest.supportedNetworks = [.amex,.masterCard,.visa,.chinaUnionPay]
        ///设置交易处理方式，3DS必须支持，EMV可选。推荐两者都支持
        payRequest.merchantCapabilities = [.capability3DS, .capabilityEMV]
        
        
        ///支付额外设置项目内容
        ///mantissa：表示十进制的位数部分【当下就是1275】
        ///exponent：标识应该乘以10的多少次，负数表示向左移动/正数表示向右移动 几位 【当下-2表示向左移动2位 = 12.75/-1为127.5】
        ///isNegative：表示生成的是 false/正数 还是 true/负数
        
        ///这里用两个数据表示原价subtotal和优惠金额discount
        let subtotalAmount = NSDecimalNumber.init(mantissa: 1275, exponent: -2, isNegative: false)
        
        let discountAmount = NSDecimalNumber.init(mantissa: 200, exponent: -2, isNegative: true)

        ///将两者结合计算出最终价格 12.75 - 2.00
        let totalAmount = NSDecimalNumber.zero
        totalAmount.adding(subtotalAmount)
        totalAmount.adding(discountAmount)
        
        
        
        ///将显示总计内容
        payRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "总金额", amount: subtotalAmount),
            PKPaymentSummaryItem(label: "优惠金额", amount: discountAmount),
            PKPaymentSummaryItem(label: "最终金额", amount: totalAmount)]
        
        ///配送方式设置
        let freeShipping = PKShippingMethod.init(label: "包邮", amount: NSDecimalNumber.zero)
        freeShipping.identifier = "freeshipping"
        freeShipping.detail = "1分钟之内到账"
        
        let expressShipping = PKShippingMethod.init(label: "超级加速", amount: NSDecimalNumber.init(string: "10.00"))
        expressShipping.identifier = "expressshipping"
        expressShipping.detail = "秒到账"
        
        
        
        ///配送的信息和账单信息 方法已经过期 todo
        ///用户可以自己处理自己的联系方式内容 todo
        payRequest.requiredBillingAddressFields = PKAddressField.all
        payRequest.requiredShippingAddressFields = PKAddressField.all
        
        

        ///保存其他信息。接收的是一个Data类型参数
        let applicationData = ["payId":"123"]
        do {
            let jsonData = try JSONEncoder().encode(applicationData)
            payRequest.applicationData = jsonData
        }catch{
            
        }
        
        
        ///授权支付
        let payViewController = PKPaymentAuthorizationViewController.init(paymentRequest: payRequest)
        
        if payViewController != nil {
            //开始设置代理，弹出支付弹窗
//            payViewController?.delegate = self
            
        }
        
        
        ///-----凭证处理 todo
    }
    
    //MARK: - 支付协议
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
//            //支付凭证。发送给服务端校验
//    }
//
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        //完成关闭
//    }
    
    
}
