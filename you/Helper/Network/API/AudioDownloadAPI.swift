//
//  DownloadRequest.swift
//  you
//  下载功能网络请求封装
//  Created by 翁益亨 on 2024/7/11.
//

import Foundation
import Alamofire

class AudioDownloadAPI : NetworkRequestHelper{
    ///class func ：属于类本身，不需要创建对象来调用
    ///func ：属于对象，需要创建对象来进行调用
    
    ///下载音频链接，如果不设置目标目录就会选择默认的推荐目录
    class func downloadAudio(downloadURL:String){
        
        // 创建一个 destination 闭包，它将文件下载到 Documents 目录
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            //添加完整存储路径信息
            let fileURL = documentsURL.appendingPathComponent("/\(audioDirectory)/downloadedAduio.mp3")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let path = "https://api-wx-painting-question-ai.calamari.cn/static/articleAudio/1-1710385035.mp3"
        
        AF.download(path, to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .response { response in
                if let error = response.error {
                    print("Download failed with error: \(error)")
                } else {
                    print("Download completed successfully")
                }
            }
        
    }
}
