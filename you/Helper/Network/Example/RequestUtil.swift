//
//  RequestUtil.swift
//  you
//
//  Created by 翁益亨 on 2024/7/11.
//

import Foundation
import OHHTTPStubsSwift
import OHHTTPStubs

//MARK: - URL统一管理的结构体
struct URLApi {
    static let baseURL = "http://lightnetwork.com"
    static let goods = "/goods"
    static let modify = "/modify"
}


//MARK: - 模拟网络请求返回内容
class RequestUtil {
    
    static let expectResponseData : [String : Any] = [
        "code" : 200,
        "message" : "success",
        "data" : [
            "goodsId" : "1234",
            "goodsBrand" : "top"
        ]
    ]
    
    ///模拟服务器获取了请求的request操作
    static func mockServer() {
        
        HTTPStubs.stubRequests { requeset in
            return requeset.url?.host == "lightnetwork.com"
        } withStubResponse: { request in
            guard let url = request.url else { return HTTPStubsResponse.init()}
            //url.path() 在iOS系统16.0版本才可用
            switch getPath(from: url) {
            case URLApi.goods, URLApi.modify:
                return HTTPStubsResponse(jsonObject: expectResponseData, statusCode: 200, headers: nil)
            default:
                return HTTPStubsResponse.init()
            }
            
        }
        
        NetworkManager.default.configuration.baseURL = URL(string: URLApi.baseURL)
    }
}

func getPath(from url: URL) -> String? {
    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    if components != nil{
        return components!.path
    }
    
    // 如果所有方法都失败，返回nil
    return nil
}
