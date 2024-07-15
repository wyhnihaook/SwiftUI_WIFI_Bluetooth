//
//  FileListOnCloudAPI.swift
//  you
//  文件列表获取
//  Created by 翁益亨 on 2024/7/15.
//

import Foundation

//文件标签信息
struct FileLabelData : Codable{
    ///标签的类型
    let labelId : Int
    ///标签展示内容
    let labelName : String
    ///标签展示的文本颜色
    let labelColor : String
}

//文件列表信息
struct FileOnCloudData : Codable{
    ///录音文件Id信息
    let recordId : Int
    
    ///展示标题
    var title : String
    
    ///记录时间
    var createdTime : String
    
    ///音频文件时长
    var duration : String
    
    ///标签
    var labels : [FileLabelData]
    
    ///关键字列表
    var keywords : [String]
    
    ///转化状态. 0/未转化 1/已转化 【转化代表上传到了云端进行了AI解析】
    var transferStatus : Int
    
}

//网络请求返回的数据源
struct FileOnCloudResultData : Codable{
    ///总数
    let total : Int
    
    ///分页获取的列表内容
    let records : [FileOnCloudData]
}

class FileListOnCloudAPI : NetworkRequestHelper{
    
    //获取云端音频文件列表。分页查询列表内容
    class func getFileListOnCloud(pageSize : Int = 10, pageNo: Int = 1, success :@escaping RequestSuccess<ResponseResultData<FileOnCloudResultData>>){
        ///这里指定了success方法回调并执行指定的类型转化，返回后由传递的success函数体中进行数据处理
        ///返回示例：{total : 100 , records:[FileOnCloudData类型数据]} -> 指定结构体

        self.request(path: URLApi.getListOnCloud, method: .post,success: success){ request, errorDescription in
            //请求失败情况处理对应的业务
        }
    }
    
    //MARK: - mock 静态数据
    class func getFileListOnCloudMock(pageSize : Int = 10, pageNo: Int = 1, success :@escaping RequestSuccess<ResponseResultData<FileOnCloudResultData>>){
        
        let fileLabelData1 = FileLabelData(labelId: 1, labelName: "标题1", labelColor: "#FF0000")
        let fileLabelData2 = FileLabelData(labelId: 2, labelName: "标题2", labelColor: "#00FF00")

        let fileOnCloudData1 = FileOnCloudData(recordId: 1, title: "模拟标题数据1", createdTime: "2020-11-11 11:11:11", duration: "11m 11s", labels: [fileLabelData1], keywords: ["关键字1"], transferStatus: 0)
        
        let fileOnCloudData2 = FileOnCloudData(recordId: 2, title: "模拟标题数据2", createdTime: "2020-02-22 22:22:22", duration: "22m 22s", labels: [fileLabelData2], keywords: ["关键字2"], transferStatus: 0)
        
        let resultData = FileOnCloudResultData(total: 2, records: [fileOnCloudData1,fileOnCloudData2])
        
        var responseResultData = ResponseResultData(code: 200, data: resultData)
        
        success(NetworkRequestHelper.init(), &responseResultData)
    }
    
}
