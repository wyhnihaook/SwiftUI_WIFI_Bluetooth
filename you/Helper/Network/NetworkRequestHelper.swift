//
//  NetworkHelper.swift
//  you
//  网络请求相关帮助类
//  Created by 翁益亨 on 2024/7/11.
//

import Alamofire
import Foundation

open class NetworkRequestHelper: NetworkBaseRequest {
    ///@discardableResult  属性可以帮我们消除因方法返回值未被使用而出现的 警告 或 下划线
    
    @discardableResult
    open class func get<T: Decodable>(path: String, parameters: Parameters? = nil, success: RequestSuccess<T>?, failure: RequestFailure? = nil) -> DataRequest? {
        self.request(path: path, parameters: parameters, success: success, failure: failure)
    }
    
    @discardableResult
    open class func post<T: Decodable>(path: String, parameters: Parameters? = nil, success: RequestSuccess<T>?, failure: RequestFailure? = nil) -> DataRequest? {
        self.request(path: path, method: .post, parameters: parameters, success: success, failure: failure)
    }
    
    /// Creates a `DataRequest` with path, method and parameters
    /// - Parameters:
    ///   - path: `path` for concatenating request  url.
    ///   - method: `HTTPMethod` for the `URLRequest`. `.get` by default.
    ///   - parameters: `Parameters` (a.k.a. `[String: Any]`) value to be encoded into the `URLRequest`. `nil` by default.
    ///   - success: call back when request success
    ///   - failure: call back when request failure
    /// - Returns: The created `DataRequest`.
    @discardableResult
    open class func request<T: Decodable>(path: String, method: HTTPMethod = .get, parameters: Parameters? = nil, success: RequestSuccess<T>?, failure: RequestFailure?) -> DataRequest? {
        // init with class object
        let req: NetworkRequestHelper = self.init(path: path)
        if req.prepareRequest(path: path, method: method, parameters: parameters) == false {
            return nil
        }
        return req.manager.request(req.url,
                                   method: req.method,
                                   parameters: req.parameters,
                                   encoding: req.encoding,
                                   headers: req.headers,
                                   interceptor: req.interceptor,
                                   requestModifier: { request in
                                       try req.modify(request: &request)
                                   }).response { response in
            req.process(response: response, success: success, failure: failure)
            req.config.networkInterceptor?.interceptor(end: req)
        }
    }
    
    open func prepareRequest(path: String, method: HTTPMethod = .get, parameters: Parameters? = nil) -> Bool {
        self.method = method
        let allow: Bool = self.config.networkInterceptor?.interceptor(allow: self) ?? true
        if allow == false || self.allowRequest == false {
            return false
        }
        
        let para: Parameters? = self.config.networkInterceptor?.interceptor(self, parameter: parameters) ?? parameters
        self.parameters = para
        
        let headers: HTTPHeaders? = self.config.networkInterceptor?.interceptor(self, headerFields: self.headers) ?? self.headers
        self.headers = headers
        
        config.networkInterceptor?.interceptor(start: self)
        return true
    }
    
    /// Process the response for all of `DataRequest`
    /// Override this method when you want to handle the response, you have to call the success and failure closure manually
    /// - Parameters:
    ///   - response: the response of the `DataRequest`
    ///   - success: call back when request success
    ///   - failure: call back when request failure
    open func process<T: Decodable>(response: AFDataResponse<Data?>, success: RequestSuccess<T>?, failure: RequestFailure? = nil) {
        switch response.result {
        case let .success(data):
            guard let sourceData = data else { return }
            do {
                //直接转化为字典   [:] 返回 -> 这里升级为直接指定【结构体】
//                let jsonData = try JSONSerialization.jsonObject(with: sourceData, options: .allowFragments)
//                success?(self, jsonData)

                //需要通过泛型来提前指定返回的数据类型，这里直接返回对应的格式内容。接收的是Data类型的data数据直接转化
                var decodedObject = try JSONDecoder().decode(T.self, from: sourceData)
                //因为需要同步修改，所以传递的是原始的数据地址信息
                success?(self, &decodedObject)
            } catch {
                let error = AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
                failure?(self, error)
            }
        case let .failure(error):
            failure?(self, error)
        }
    }
    
    /// Creates a `UploadRequest` with path, method, parameters, and multipartFormData
    /// - Parameters:
    ///   - path: `path` for concatenating request  url.
    ///   - method: `HTTPMethod` for the `URLRequest`. `.get` by default.
    ///   - parameters: `Parameters` (a.k.a. `[String: Any]`) value to be encoded into the `URLRequest`. `nil` by default.
    ///   - multipartFormData: `MultipartFormData` building closure.
    ///   - success: call back when request success
    ///   - failure: call back when request failure
    /// - Returns: The created `UploadRequest`.
    @discardableResult
    open class func upload<T: Decodable>(
        path: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        multipartFormData: @escaping (MultipartFormData) -> Void,
        success: RequestSuccess<T>?,
        failure: RequestFailure? = nil) -> UploadRequest?
    {
        // init with class object
        let req: NetworkRequestHelper = self.init(path: path)
        if req.prepareRequest(path: path, method: method, parameters: parameters) == false {
            return nil
        }
        return req.manager.upload(multipartFormData: multipartFormData,
                                  to: req.url,
                                  method: req.method,
                                  headers: req.headers,
                                  interceptor: req.interceptor,
                                  requestModifier: { request in
                                      try req.modify(request: &request)
                                  })
                                  .response { response in
                                      req.process(response: response, success: success, failure: failure)
                                      req.config.networkInterceptor?.interceptor(end: req)
                                  }
    }
    
    /// Creates a `DownloadRequest` with path, method, parameters, and destination
    /// - Parameters:
    ///   - path: `path` for concatenating request  url.
    ///   - method: `HTTPMethod` for the `URLRequest`. `.get` by default.
    ///   - parameters: `Parameters` (a.k.a. `[String: Any]`) value to be encoded into the `URLRequest`. `nil` by default.
    ///   - success: call back when request success
    ///   - failure: call back when request failure
    ///   - destination: `DownloadRequest.Destination` closure used to determine how and where the downloaded file should be moved. `nil` by default.
    /// - Returns: The created `DownloadRequest`.
    @discardableResult
    open class func download<T: Decodable>(path: String, method: HTTPMethod = .get, parameters: Parameters? = nil, success: RequestSuccess<T>?, failure: RequestFailure? = nil, to destination: DownloadRequest.Destination? = nil) -> DownloadRequest? {
        // init with class object
        let req: NetworkRequestHelper = self.init(path: path)
        if req.prepareRequest(path: path, method: method, parameters: parameters) == false {
            return nil
        }
        let destination2 = destination ?? DownloadRequest.suggestedDownloadDestination()
        return req.manager.download(req.url,
                                    method: req.method,
                                    parameters: req.parameters,
                                    encoding: req.encoding,
                                    headers: req.headers,
                                    interceptor: req.interceptor,
                                    requestModifier: { request in
                                        try req.modify(request: &request)
                                    },
                                    to: destination2)
            .response { response in
                req.processDownload(response: response, success: success, failure: failure)
                req.config.networkInterceptor?.interceptor(end: req)
            }
    }
    
    /// Process the response for all of `DownloadRequest`
    /// Override this method when you want to handle the response, you have to call the success and failure closure manually
    /// - Parameters:
    ///   - response: the response of the `DownloadRequest`
    ///   - success: call back when request success
    ///   - failure: call back when request failure
    open func processDownload<T>(response: AFDownloadResponse<URL?>, success: RequestSuccess<T>?, failure: RequestFailure? = nil) {
        switch response.result {
        case let .success(data):
            //这里将响应的地址处理返回
            let url = data?.absoluteString ?? ""

            //固定格式的json格式字符串返回。创建一个结构体进行组装后处理返回。这里的T要设置为对应返回的结构体类型
            var downloadResult = DownloadResultData(downloadURL: url)  as! T
            //因为需要同步修改，所以传递的是原始的数据地址信息
            success?(self, &downloadResult)
            
            
//            success?(self, data?.absoluteString as T)
        case let .failure(error):
            failure?(self, error)
        }
    }
}

struct DownloadResultData : Codable{
    let downloadURL : String
}
