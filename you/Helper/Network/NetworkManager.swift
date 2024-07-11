//
//  NetworkManager.swift
//  you
//  网络的管理封装类，创建网络请求对象。【实际用来发起的网络请求】
//  Created by 翁益亨 on 2024/7/11.
//

import Foundation
import Alamofire

open class NetworkManager {
    public var configuration: NetworkConfiguration
    public var session: Alamofire.Session = Session()
    
    var baseURL: URL {
        assert(configuration.baseURL != nil, "Please config the baseURL")
        return configuration.baseURL!
    }

    var requestInterceptor: NetworkInterceptor? {
        configuration.networkInterceptor
    }
    
    public static let `default` = NetworkManager()
    
    public init(configuration: NetworkConfiguration) {
        self.configuration = configuration
    }
    
    convenience init() {
        self.init(
            configuration: NetworkConfiguration(baseURL: nil)
        )
    }
    
    /// clear request cache
    class func clearRequestCache() {
        URLCache.shared.removeAllCachedResponses()
    }
    
    @discardableResult
    func request(
        _ convertible: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        interceptor: RequestInterceptor? = nil,
        requestModifier: Alamofire.Session.RequestModifier? = nil
    ) -> DataRequest {
        return session.request(convertible, method: method, parameters: parameters, encoding: encoding, headers: headers, interceptor: interceptor, requestModifier: requestModifier)
    }
    
    //根据URL信息下载到对应的目标
    @discardableResult
    func download(
        _ convertible: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        interceptor: RequestInterceptor? = nil,
        requestModifier: Alamofire.Session.RequestModifier? = nil,
        to destination: DownloadRequest.Destination? = nil
    ) -> DownloadRequest {
        return session.download(convertible, method: method, parameters: parameters, encoding: encoding, headers: headers, interceptor: interceptor, requestModifier: requestModifier, to: destination)
    }
    
    @discardableResult
    func upload(
        multipartFormData: @escaping (
            MultipartFormData
        ) -> Void,
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil,
        interceptor: RequestInterceptor? = nil,
        requestModifier: Alamofire.Session.RequestModifier? = nil
    ) -> UploadRequest {
        return session.upload(multipartFormData: multipartFormData, to: url, usingThreshold: configuration.encodingMemoryThreshold, method: method, headers: headers, interceptor: interceptor, fileManager: configuration.uploadFileManager, requestModifier: requestModifier)
    }}
