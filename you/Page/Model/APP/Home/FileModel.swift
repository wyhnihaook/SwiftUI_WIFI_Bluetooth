//
//  FileModel.swift
//  you
//  获取本地数据内容
//  Created by 翁益亨 on 2024/7/11.
//


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
    
     
}
