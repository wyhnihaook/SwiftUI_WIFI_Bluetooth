//
//  ExampleInterceptor.swift
//  you
//  拦截器处理请求事件示例
//  Created by 翁益亨 on 2024/7/11.
//

import Foundation
import Alamofire

class ExampleInterceptor : NetworkInterceptor {
    
    func interceptor(allow request: NetworkBaseRequest) -> Bool {
        return true
    }
    
    func interceptor(start request: NetworkBaseRequest) {
        print("start")
    }
    
    func interceptor(end request: NetworkBaseRequest) {
        print("end")
    }
    
    func interceptor(_ request: NetworkBaseRequest, parameter: Alamofire.Parameters?) -> Alamofire.Parameters? {
        var para : Alamofire.Parameters = parameter ?? Alamofire.Parameters.init()
        para["common"] = "nb"
        return para
    }
    
    func interceptor(_ request: NetworkBaseRequest, headerFields: Alamofire.HTTPHeaders?) -> Alamofire.HTTPHeaders? {
        var headers :  Alamofire.HTTPHeaders = headerFields ?? Alamofire.HTTPHeaders.init()
        headers.add(name: "public", value: "nb")
        return headers
    }
}
