//
//  FileModel.swift
//  you
//  获取本地数据内容
//  Created by 翁益亨 on 2024/7/11.
//


///文件的基本信息
struct FileInformation:Identifiable{
    var id = UUID()
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
    //本地文件内容获取
    @Published var fileNameList : [FileInformation] = []
    
    init(){
        //初始化时获取对应的本地文件列表
        let fileURLs = self.listFilesInDirectory()
        for file in fileURLs{
            fileNameList.append(file)
        }
    }
    
    func listFilesInDirectory() ->[FileInformation]{
        let directoryPath = FileUtil.getAudioDirectory(path: audioDirectory)
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: URL(fileURLWithPath: directoryPath), includingPropertiesForKeys: nil)
            
            print("file count :\(fileURLs.count)")
            
            
            return fileURLs.map {
                var fileInformation = FileInformation()
                do {
                    // 检查文件是否存在
                    if fileManager.fileExists(atPath: $0.path) {
                        //文件名称获取
                        let url = URL(fileURLWithPath: $0.path)
                       
                        fileInformation.fileName = url.pathComponents.last ?? ""
                        
                        let attributes = try fileManager.attributesOfItem(atPath: $0.path)
                        
                        
                        // 获取文件大小
                        if let fileSize = attributes[FileAttributeKey.size] as? Int {
                            print("File size: \(fileSize) bytes")
                            
                            fileInformation.fileSize = "\(fileSize)B"
                        }
                        
                        // 获取创建日期
                        if let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
                            print("Creation date: \(creationDate)")
                            
                            fileInformation.createTime = DateUtil.convertToString(date: creationDate)
                        }
                        
                        // 获取最后修改日期
                        if let modificationDate = attributes[FileAttributeKey.modificationDate] as? Date {
                            print("Modification date: \(modificationDate)")
                            
                            fileInformation.updateTime = DateUtil.convertToString(date: modificationDate)
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
