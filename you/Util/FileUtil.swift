//
//  FileUtil.swift
//  you
//
//  Created by 翁益亨 on 2024/7/11.
//

import Foundation


class FileUtil{
    
    static func getAudioDirectory(path:String) -> String{
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        // 定义你要创建的目录的完整路径
        let directoryPath = "\(documentsDirectory)/\(path)"
        
        return directoryPath
    }
    
    static func createDirectory(path:String){
        let directoryPath = FileUtil.getAudioDirectory(path: path)
        if fileManager.fileExists(atPath: directoryPath) {
        } else {
            // 创建目录，如果不存在的话
            do {
                try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
                print("Directory created at \(directoryPath)")
            } catch {
                print("Error creating directory: \(error)")
            }
        }
       
    }
    
    
    
    static func listFilesInDirectory(atPath path: String) -> [String]? {
        let fileManager = FileManager.default
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: URL(fileURLWithPath: path), includingPropertiesForKeys: nil)
            return fileURLs.map { $0.path }
        } catch {
            print("Error while enumerating files \(error)")
            return nil
        }
    }
}
