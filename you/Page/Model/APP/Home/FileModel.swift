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
    
    //文件下载进度同步
    @Published var showProgressIndicator: Bool = true
    @Published var progress: CGFloat = 0.0
    @Published var enableAutoProgress: Bool = true
    @Published var progressForDefaultSector: CGFloat = 0.0
    let timer = Timer.publish(every: 1 / 5, on: .main, in: .common).autoconnect()

    
    //文件列表信息【由外设同步而来】。外设文件的详细信息
    @Published var fileCacheList : [FileInformation] = []
    //当前已经完成的文件下载个数信息
    @Published var finishSyncFile : Int = 0
    //当前同步文件的进度【实际上是同步bit和大小的进度情况】。默认为0
    @Published var currentFileCache = 0
    
    init(){
        //初始化时获取对应的本地文件列表
//        let fileURLs = self.listFilesInDirectory()
//        for file in fileURLs{
//            fileOnLocalList.append(file)
//        }

        //初始化获取云端数据
        FileListOnCloudAPI.getFileListOnCloudMock { request, responseData in
            
            //进行赋值
            if responseData.data.records.isNotEmpty{
//                self.fileOnCloudList = responseData.data.records
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
                    
                    for item in list{
                        ///获取结果的时候，存在关联表内容时，会被包装成一个Pointer，其中含有objectId用来查询标签表数据。这里要提前做一次转化

                        let labels = item.get("labels") as! LCArray

                        ///获取数据库数据都为异步操作，所以这里要处理分情况处理
                        if !labels.isEmpty{
                            let queryLabel = LCQuery(className: fileLabel)
                            
                            //数组查询
                            var labelObjectIds:[String] = []
                            for label in labels{
                                print((label as! LCObject).objectId!)
                                labelObjectIds.append((label as! LCObject).objectId!.value)
                            }
                            
                            //containedIn数组中满足一个就会返回
                            //containedAllIn数组中所有条件都需要满足
                            queryLabel.whereKey("objectId", .containedIn(labelObjectIds))
                            queryLabel.find { result in
                                switch result {
                                case .success(objects: let labelInfos):
                                    //满足的内容。替换数据源
                                    do{
                                        try item.set("labels", value: labelInfos)
                                    }catch{
                                        print("file List labels error:\(error)")
                                    }
                                    
                                    
                                    self.convertDatabase(item)
                                    
                                case .failure(error: let error):
                                    print(error)
                                }
                            }

                        }else{
                            
                            self.convertDatabase(item)
                        }
                   
                    }
                    
                case .failure(error: let error):
                    if error.code == 101{
                        //说明没有数据表结构，所以这里要进行新建。新建后返回。这里以模版内容新建
                        //数据表结构内容参考：FileOnCloudData
                        //注意⚠️：只能创造数据后才会有表结构跟随创建，所以这里初始化设置数据内容
                        
                        self.initFileDatabase(userId: currentUserObjectId)
                        self.initRecordDetail()
                    }
                    print(error)
                }
            }
        } else {
            // 显示注册或登录页面
        }
        
        
    }
    
    ///文件内容转化
    private func convertDatabase(_ item: LCObject){
        if let fileOnCloudData:FileOnCloudData =  decodeMap(from: item.jsonValue as! [String : Any]){
            //存在数据的情况，渲染在页面上
            self.fileOnCloudList.append(fileOnCloudData)
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

            ///录音文件Id信息。这个需要关联音频文件的表结构【用于发起具体音频的详情信息】
            ///音频文件基本信息单独存放 - 云端的静态数据【当前在数据库创建的表Audio中存储文件信息】
            try fileInfo.set("recordId", value: 1)
            ///展示标题
            try fileInfo.set("title", value: "模拟云数据")
            ///记录时间
            try fileInfo.set("createdTime", value: "2020-11-11 11:11:11")
            ///音频文件时长
            try fileInfo.set("duration", value: "11m 11s")
            ///【一对多的关系，一个文件信息可能会有多个标签的情况】
            ///保存数据时，会生成对应的fileLabel关联表进行数据传递
            var labels:[LCObject] = []
//            for item in FileListOnCloudAPI.getFileLabel(){
//                ///首先去查询是否存在固定的初始化的标签信息，如果不存在就从以下内容进行添加。如果存在直接通过设置对应的objectId进行关联【标签库应该在上线时就进行初始化】
//                let fileLabel = LCObject(className: fileLabel)
//
//                // 为属性赋值
//                try fileLabel.set("labelId", value: item.labelId)
//                try fileLabel.set("labelName", value: item.labelName)
//                try fileLabel.set("labelColor", value: item.labelColor)
//
//                labels.append(fileLabel)
//            }
            
            //直接通过标签库关联内容【已经存在的数据直接关联】
            let label1 = LCObject(className: fileLabel, objectId: "66a85c6ff092fd15e6934049")
            let label2 = LCObject(className: fileLabel, objectId: "66a85c6ff092fd15e6934048")

            labels = [label1, label2]
            

            try fileInfo.set("labels", value: labels)
            ///关键字列表，可以直接同步数组
            try fileInfo.set("keywords", value: ["关键字","非常好"])

            ///转化状态. 0/未转化 1/已转化 【转化代表上传到了云端进行了AI解析】
            try fileInfo.set("transferStatus", value: 1)

            ///关联用户的数据
            try fileInfo.set("userId", value: userId)

            // 将对象保存到云端
            _ = fileInfo.save { result in
                switch result {
                case .success:
                    //存在数据的情况，渲染在页面上
                    //这里需要重新获取label信息进行展示
                    let queryLabel = LCQuery(className: fileLabel)
                    
                    //数组查询
                    var labelObjectIds:[String] = []
                    for label in labels{
                        labelObjectIds.append(label.objectId!.value)
                    }
                    
                    //containedIn数组中满足一个就会返回
                    //containedAllIn数组中所有条件都需要满足
                    queryLabel.whereKey("objectId", .containedIn(labelObjectIds))
                    queryLabel.find { result in
                        switch result {
                        case .success(objects: let labelInfos):
                            //满足的内容。替换数据源
                            do{
                                try fileInfo.set("labels", value: labelInfos)
                            }catch{
                                print("file List labels error:\(error)")
                            }
                            
                            self.convertDatabase(fileInfo)

                            
                        case .failure(error: let error):
                            print(error)
                        }
                    }
                        
                case .failure(error: let error):
                    // 异常处理
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    
    //MARK: - 文件详情初始化时生成【点击详情查看的内容初始化】
    func initRecordDetail(){
        do {
            // 构建对象
            let fileDetail = LCObject(className: fileDetail)

            //基于当前的FileOnCloudData进行扩展字段
            ///查询详情标记
            try fileDetail.set("recordId", value: 1)
            ///展示标题
            try fileDetail.set("title", value: "模拟云数据")
            ///记录时间
            try fileDetail.set("createdTime", value: "2020-11-11 11:11:11")
            ///音频文件时长
            try fileDetail.set("duration", value: "11m 11s")
            ///【一对多的关系，一个文件信息可能会有多个标签的情况】
            ///保存数据时，会生成对应的fileLabel关联表进行数据传递
            var labels:[LCObject] = []

            //直接通过标签库关联内容【已经存在的数据直接关联】
            let label1 = LCObject(className: fileLabel, objectId: "66a85c6ff092fd15e6934049")
            let label2 = LCObject(className: fileLabel, objectId: "66a85c6ff092fd15e6934048")

            labels = [label1, label2]
            

            try fileDetail.set("labels", value: labels)
            ///关键字列表，可以直接同步数组
            try fileDetail.set("keywords", value: ["关键字","非常好"])
            
            ///转写记录
            let transferList = [FileTransferData(pointTime: "00:00:00", content: "嬉皮笑脸", transferId: 1),FileTransferData(pointTime: "00:00:05", content: "有时候的天气时阴天", transferId: 2)]
            
            var transferCloudList:[LCObject] = []
            
            for item in transferList{
                let fileTransfer = LCObject(className: fileTransfer)
            
                // 为属性赋值
                try fileTransfer.set("pointTime", value: item.pointTime)
                try fileTransfer.set("content", value: item.content)
                try fileTransfer.set("transferId", value: item.transferId)
            
                transferCloudList.append(fileTransfer)
            }
            try fileDetail.set("transferList", value: transferCloudList)

            ///总结 如果要存储字符串数组的情况，就要用指针Pointer指向表中的另外一条数据
            ///["总结内容1","总结内容2","总结内容3","总结内容4","总结内容5","总结内容6","总结内容7","总结内容8"]
            try fileDetail.set("conclusion",  value:"总结内容1\n总结内容2\n总结内容3\n总结内容4\n总结内容5\n总结内容6\n总结内容7")
            ///思维导图待定
            try fileDetail.set("mindMap",  value:"思维导图")
            
            ///音频文件地址
            try fileDetail.set("fileUrl",  value:"https://file-leancloud.calamari.cn/VdvMhTfyu3zVwwAwB5rplhCqABcOcUPo/4811da4f75ad4683be51e248356bd0b9")

           

            // 将对象保存到云端
            _ = fileDetail.save { result in
                switch result {
                case .success:
                    //保存详情信息，不做任何处理
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
