//
//  NetworkConfiguration.swift
//  you
//
//  Created by 翁益亨 on 2024/7/11.
//

import Foundation
import Alamofire

public struct NetworkConfiguration {
    
    /// let baseURL : URL = URL(string: "http://example.com/v1/")
    ///  用于从相对路径构造请求的URL。示例：https://www.baidu.com
    ///  用于拼接后示例：https://www.baidu.com/api?work=vip
    public var baseURL: URL? {
        didSet {
            processBaseURL()
        }
    }
    
    /// 发起请求的拦截器，用于额外对request发起前的二次【加工处理参数】
    public var networkInterceptor: NetworkInterceptor?
    
    /// 日志输入等级
    public var debugLevel: DebugLevel
    
    /// 默认编码设置
    public var encodingMemoryThreshold: UInt64
    
    /// `FileManager` 用于upload上传文件控制
    public var uploadFileManager: FileManager
    
    
    public init(baseURL: URL?, networkInterceptor: NetworkInterceptor? = nil, debugLevel: DebugLevel = .all, encodingMemoryThreshold: UInt64 = MultipartFormData.encodingMemoryThreshold, uploadFileManager: FileManager = .default) {
        self.baseURL = baseURL
        self.networkInterceptor = networkInterceptor
        self.debugLevel = debugLevel
        self.encodingMemoryThreshold = encodingMemoryThreshold
        self.uploadFileManager = uploadFileManager
        processBaseURL()
    }
    
    mutating func processBaseURL() {
        if let url : URL = baseURL {
            if url.path.count > 0 && !url.absoluteString.hasSuffix("/") {
                baseURL = url.appendingPathComponent("")
            }
        }
    }
}


public enum DebugLevel: Int {
    case none
    case error
    case all
}

public func DebugPrint(message: String, level: DebugLevel) {
    switch NetworkManager.default.configuration.debugLevel {
    case .none: return
    case .error: if level == .error { print(message) }
    case .all: print(message)
    }
}
