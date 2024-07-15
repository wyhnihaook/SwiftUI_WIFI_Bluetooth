//
//  NetworkBaseRequest.swift
//  you
//  基于Alamofire的轻量级封装
//  网络请求基类，声明了所有的变量以及回调的函数内容
//  Created by 翁益亨 on 2024/7/11.
//

import Foundation
import Alamofire

public typealias RequestSuccess<T> = (_ request: NetworkBaseRequest, _ responseData: inout T) -> Void
public typealias RequestFailure = (_ request: NetworkBaseRequest, _ error: Error) -> Void


open class NetworkBaseRequest: NSObject {
    
    /// 获取网络请求的管理对象
    open var manager: NetworkManager { NetworkManager.default }
    
    /// 获取网络请求的基础配置信息
    open var config: NetworkConfiguration { manager.configuration }

    /// 每一个请求必须要填写的路径信息
    open var path: String = ""
    
    /// 最终结合baseURL + path 的请求路径【用于发起的请求路径】
    open var url : URL {
        URL(string: path, relativeTo: manager.baseURL) ?? manager.baseURL
    }
    
    ///  发起请求类型。【默认 get请求】
    open var method: HTTPMethod = .get
    
    /// 请求参数
    open var parameters: Parameters?
    
    /// 拦截器设定，默认 nil
    open var interceptor: RequestInterceptor?
    
    /// 网络请求的额外操作处理【获取Session对象进行会话对象的操作】
    open var requestModifier: Alamofire.Session.RequestModifier?
    
    /// 用于将“parameters”值编码格式
    open var encoding: ParameterEncoding = URLEncoding.default
    
    /// 请求头设置，默认 nil
    open var headers: HTTPHeaders?
    
    /// The cache policy of the `URLRequest`.`.useProtocolCachePolicy` by default.
    open var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy

    /// 网络请求超时时间设置
    open var timeoutInterval: TimeInterval = 60

    /// 是否允许发起网络请求
    open var allowRequest: Bool { true }

    override public required init() {}

    public required convenience init(path: String) {
        self.init()
        self.path = path
        prepare()
    }
    
    ///用于网络请求初始化后做的额外操作，覆写实现
    open func prepare() {}
    
    internal func modify(request:inout URLRequest) throws  {
        request.timeoutInterval = timeoutInterval
        request.cachePolicy = cachePolicy
        try requestModifier?(&request)
    }

    override public var description: String {
        var des = String(describing: super.description)
        des = des.appendingFormat("\npath : %@", path)
            .appendingFormat("\nabsoluteURL : %@", url.absoluteString)
            .appendingFormat("\nmethod : %@", method.rawValue)
            .appendingFormat("\nparameters : %@", parameters ?? [:])
            .appendingFormat("\nhttpHeaders : %@", headers?.dictionary.description ?? [:])
            
        return des
    }

    deinit {
        DebugPrint(message: "deinit Request:" + self.description, level: .all)
    }
}
