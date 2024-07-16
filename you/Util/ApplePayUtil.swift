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


//支付模式一：PKPaymentRequest + PKPaymentAuthorizationController 【Apple Pay】与App Store内的购买时不同的
//支付模式一是用于实体商品和服务的购买，而App Store用于数字内容或者应用内的服务购买

//如果你想要一个类遵循NSObjectProtocol，则必须让它继承自NSObject
class ApplePayUtil :NSObject, PKPaymentAuthorizationControllerDelegate{
    
    
    //支持的储蓄卡/信用卡信息
       static let supportedNetworks: [PKPaymentNetwork] = [
        .amex, .cartesBancaires, .chinaUnionPay, .discover,
                .eftpos, .electron, .elo, .idCredit, .interac,
                .JCB, .mada, .maestro, .masterCard, .privateLabel,
        .quicPay, .suica, .visa, .vPay, .mir
       ]

    
    //支付弹窗控制对象
    private var paymentController : PKPaymentAuthorizationController?
    
    
    //判断是否支持Apple Pay 支付 【这里涵盖了支付宝/微信/银行卡信息的结果，只要支持就是允许网络付款】
    //判断是否添加了支付的储蓄卡/信用卡【注意：只针对储蓄卡/信用卡】
    class func applePayStatus() -> (canMakePayments: Bool, canSetupCards: Bool) {
        return (PKPaymentAuthorizationController.canMakePayments(),
                PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks))
    }
    
    
    //创建支付请求，由于部分信息可以由用户修改，所以需要设置为变量
    func createPayRequest(){
        let payRequest = PKPaymentRequest()
        ///设置币种、国家码以及之前设置的merchant ID标识符 【merchant.com.zai.you】
        ///国家代码
//        payRequest.countryCode = "CN"
        ///RMB的币种代码
//        payRequest.currencyCode = "CNY"
        
        ///通过设备来获取
        let currentLocale = Locale.current
        if let countryCode = currentLocale.regionCode {
            payRequest.countryCode = countryCode
        }

        if let currencyCode = currentLocale.currencyCode {
            payRequest.currencyCode = currencyCode
        }
                
        payRequest.merchantIdentifier = "merchant.com.zai.you"
        ///支持的支付方式
        payRequest.supportedNetworks = ApplePayUtil.supportedNetworks
        ///设置交易处理方式，3DS必须支持，EMV可选。推荐两者都支持
        ///这里要额外支持.capabilityDebit：借记卡  .capabilityCredit：信用卡。不添加到情况会支付不成功【不执行paymentAuthorizationController 系统回调】
        payRequest.merchantCapabilities = [.capability3DS, .capabilityEMV,.capabilityDebit,.capabilityCredit]
        
        
        ///支付额外设置项目内容
        ///mantissa：表示十进制的位数部分【当下就是1275】
        ///exponent：标识应该乘以10的多少次，负数表示向左移动/正数表示向右移动 几位 【当下-2表示向左移动2位 = 12.75/-1为127.5】
        ///isNegative：表示生成的是 false/正数 还是 true/负数
        
        ///这里用两个数据表示原价subtotal和优惠金额discount
        let subtotalAmount = NSDecimalNumber.init(mantissa: 1275, exponent: -2, isNegative: false)
        
        let discountAmount = NSDecimalNumber.init(mantissa: 1274, exponent: -2, isNegative: true)
        
        ///将两者结合计算出最终价格 12.75 - 12.74
        var totalAmount = NSDecimalNumber.zero
        totalAmount = totalAmount.adding(subtotalAmount)
        totalAmount = totalAmount.adding(discountAmount)
        
        
        
        ///将显示总计内容
        payRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "总金额", amount: subtotalAmount),
            PKPaymentSummaryItem(label: "优惠金额", amount: discountAmount),
            PKPaymentSummaryItem(label: "最终金额", amount: totalAmount)]
        
        ///配送方式设置 - 无需配置。收获信息和收获地址。将会影响Apple Pay的支付
//        let freeShipping = PKShippingMethod.init(label: "包邮", amount: NSDecimalNumber.zero)
//        freeShipping.identifier = "freeshipping"
//        freeShipping.detail = "1分钟之内到账"
//
//        let expressShipping = PKShippingMethod.init(label: "超级加速", amount: NSDecimalNumber.init(string: "10.00"))
//        expressShipping.identifier = "expressshipping"
//        expressShipping.detail = "秒到账"
//
//        payRequest.shippingType = .delivery
//        payRequest.shippingMethods = [freeShipping, expressShipping]
//        payRequest.requiredShippingContactFields = [.name, .postalAddress]
        
        
        
        ///保存其他信息。接收的是一个Data类型参数
        let applicationData = ["payId":"123"]
        do {
            let jsonData = try JSONEncoder().encode(applicationData)
            payRequest.applicationData = jsonData
        }catch{
            
        }
        
        
        ///授权支付
        paymentController = PKPaymentAuthorizationController(paymentRequest: payRequest)
        
        if paymentController != nil {
            //开始设置代理，弹出支付弹窗
            paymentController?.delegate = self
           
            paymentController?.present(completion: { (presented: Bool) in
                if presented {
                    debugPrint("Presented payment controller")
                } else {
                    debugPrint("Failed to present payment controller")
//                    self.completionHandler(false)
                }
            })
            
        }
        
        
    }
    
    //MARK: - 支付协议
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        //完成关闭系统支付弹窗【释放支付视图】

        //执行到这里
        paymentController?.dismiss()
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        //这里未执行到 todo --------
        //【授权时创建了一个支付令牌】这里会返回支付结果。完成之后需要同步服务端数据
        // 支付凭证：发送给服务端验证支付是否有效
        let payToken = payment.token

        //账单信息
        let billingContact = payment.billingContact

        //送货方式
        let shippingContact = payment.shippingContact

        //这里可添加额外校验。例如：地区限制等

        //发送给服务端校验完成之后调用completion来同步最终支付结果

        //模拟延时
        print("payToken:\(payToken)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
            completion(.success)
        }
    }
    
    
}
