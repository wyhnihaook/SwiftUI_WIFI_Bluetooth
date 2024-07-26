//
//  FileModel.swift
//  you
//  获取本地数据内容
//  Created by 翁益亨 on 2024/7/11.
//

import LeanCloud

///文件的基本信息
struct FileInformation:Codable{
    //文件名称
    var fileName: String
    //获取文件大小
    var fileSize: String
    //创建时间
    var createTime: String
    //最后修改时间
    var updateTime: String
    
    init(fileName: String = "", fileSize: String = "", createTime: String = "", updateTime: String = "") {
        self.fileName = fileName
        self.fileSize = fileSize
        self.createTime = createTime
        self.updateTime = updateTime
    }
}

import Foundation
class FileModel : ObservableObject{
    //本地文件内容获取【后续用于外设数据同步过来的数据处理】- 数据格式保持和云端数据一致，创建时规整数据内容
    @Published var fileOnLocalList : [FileOnCloudData] = []
    
    //云端文件列表展示
    @Published var fileOnCloudList : [FileOnCloudData] = []

    
    init(){
        //初始化时获取对应的本地文件列表
        let fileURLs = self.listFilesInDirectory()
        for file in fileURLs{
            fileOnLocalList.append(file)
        }

        //初始化获取云端数据
        FileListOnCloudAPI.getFileListOnCloudMock { request, responseData in
            
            //进行赋值
            if responseData.data.records.isNotEmpty{
                self.fileOnCloudList = responseData.data.records
            }
        }
    }
    
    func listFilesInDirectory() ->[FileOnCloudData]{
        let directoryPath = FileUtil.getAudioDirectory(path: audioDirectory)
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: URL(fileURLWithPath: directoryPath), includingPropertiesForKeys: nil)
            
            print("file count :\(fileURLs.count)")
            
            
            return fileURLs.map {
                var fileInformation = FileOnCloudData(recordId: -1, title: "", createdTime: "", duration: "0m 0s", labels: [], keywords: [], transferStatus: 0)
                
                do {
                    // 检查文件是否存在
                    if fileManager.fileExists(atPath: $0.path) {
                        //文件名称获取
                        let url = URL(fileURLWithPath: $0.path)
                       
                        fileInformation.title = url.pathComponents.last ?? ""
                        
                        let attributes = try fileManager.attributesOfItem(atPath: $0.path)
                        
                        
                        // 获取文件大小
                        if let fileSize = attributes[FileAttributeKey.size] as? Int {
                            print("File size: \(fileSize) bytes")
                        }
                        
                        // 获取创建日期
                        if let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
                            print("Creation date: \(creationDate)")
                            
                            fileInformation.createdTime = DateUtil.convertToString(date: creationDate)
                        }
                        
                        // 获取最后修改日期
                        if let modificationDate = attributes[FileAttributeKey.modificationDate] as? Date {
                            print("Modification date: \(modificationDate)")

                        }
                    } else {
                        print("File does not exist.")
                    }
                } catch {
                    print("Error getting file information: \(error)")
                }
                
                return fileInformation
                
            }
        } catch {
            print("Error while enumerating files \(error)")
            return []
        }
    }
    
     
    //获取数据源，如果没有到情况就初始化云数据库内容
    func getFileDatabase(){
        if let user = LCApplication.default.currentUser {
            let currentUserObjectId = user.objectId?.value ?? ""
            let query = LCQuery(className: fileInfo)
            ///添加查询条件【当前用户】
            query.whereKey("userId", .equalTo(currentUserObjectId))

            ///查询结果展示
            query.find { result in
                switch result {
                case .success(objects: let list):
                    // students 是包含满足条件的 fileList 对象的数组
                    print("list.isEmpty:\(list.isEmpty)")
                    break
                case .failure(error: let error):
                    if error.code == 101{
                        //说明没有数据表结构，所以这里要进行新建。新建后返回。这里以模版内容新建
                        //数据表结构内容参考：FileOnCloudData
                        //注意⚠️：只能创造数据后才会有表结构跟随创建，所以这里初始化设置数据内容
                        
                        
                        //首先创建标签【标签可复用】
                        self.initLabelDatabase()
                        self.initFileDatabase(userId: currentUserObjectId)
                    }
                    print(error)
                }
            }
        } else {
            // 显示注册或登录页面
        }
        
        
    }
    
    
    
    //MARK: - 标签数据创建【跟随文件列表表结构生成】
    
    ///当前内容根据静态数据生成。一般来说只有一条数据都没有的情况下会创建
    func initLabelDatabase(){
        for item in FileListOnCloudAPI.getFileLabel(){
            do {
                // 构建对象
                let fileLabel = LCObject(className: fileLabel)

                // 为属性赋值
                try fileLabel.set("labelId", value: item.labelId)
                try fileLabel.set("labelName", value: item.labelName)
                try fileLabel.set("labelColor", value: item.labelColor)

                // 将对象保存到云端
                _ = fileLabel.save { result in
                    switch result {
                    case .success:
                        // 成功保存之后，执行其他逻辑
                        break
                    case .failure(error: let error):
                        // 异常处理
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
        }
        
    }
    
    
    ///创建一条虚拟的文件信息用来展示
    func initFileDatabase(userId: String){
        do {
            // 构建对象
            let fileInfo = LCObject(className: fileInfo)

            // 为属性赋值。这里是关联对应需要检索的标签类型，这里就固定为1.后续根据设定模版来处理
            try fileInfo.set("labelId", value: 1)
            ///录音文件Id信息。这个需要关联音频文件的表结构 - 云端的静态数据
            try fileInfo.set("recordId", value: 1)
            ///展示标题
            try fileInfo.set("title", value: "模拟云数据")
            ///记录时间
            try fileInfo.set("createdTime", value: "2020-11-11 11:11:11")
            ///音频文件时长
            try fileInfo.set("duration", value: "11m 11s")
            ///标签具体内容实用复用的信息即可
//            try fileInfo.set("labels", value: "1")
            ///关键字列表 使用字符串逗号分隔获取后在进行处理
            try fileInfo.set("keywords", value: "关键字,非常好")

            ///转化状态. 0/未转化 1/已转化 【转化代表上传到了云端进行了AI解析】
            try fileInfo.set("transferStatus", value: 1)

            ///关联用户的数据
            try fileInfo.set("userId", value: userId)

            // 将对象保存到云端
            _ = fileInfo.save { result in
                switch result {
                case .success:
                    // 成功保存之后，执行其他逻辑
                    brea
                case .failure(error: let error):
                    // 异常处理
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
}
