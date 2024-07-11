//
//  NetworkInterceptor.swift
//  you
//  全局网络拦截器，进行全局网络请求统一配置
//  Created by 翁益亨 on 2024/7/11.
//

import Foundation
import Alamofire

public protocol NetworkInterceptor {
    func interceptor(allow request: NetworkBaseRequest) -> Bool
    
    /// 网络请求开始时的回调
    func interceptor(start request: NetworkBaseRequest) -> Void
    
    /// 网络请求完成后的回调
    func interceptor(end request: NetworkBaseRequest) -> Void
    
    /// 发起网络请求时对参数的二次处理
    func interceptor(_ request: NetworkBaseRequest, parameter: Parameters?) -> Parameters?

    ///发起网络请求对请求头进行二次处理
    func interceptor(_ request: NetworkBaseRequest, headerFields: HTTPHeaders?) -> HTTPHeaders?
}

extension NetworkInterceptor {
    //设置是否拦截标识
    func interceptor(allow request: NetworkBaseRequest) -> Bool {
        return true
    }
}
