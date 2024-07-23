//
//  DownloadRequest.swift
//  you
//  下载功能网络请求封装
//  Created by 翁益亨 on 2024/7/11.
//

import Foundation
import Alamofire
import LeanCloud

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
    
    //MARK: - 上传文件到LeanCloud
    class func uploadCloud(){
        
        //直接使用URL进行转存，URL转存，不会产生实际文件数据。访问情况取决于URL的情况
        
//        if let url = URL(string: "https://api-wx-painting-question-ai.calamari.cn/static/articleAudio/1-1710385035.mp3") {
//            let file = LCFile(url: url)
//            //保存文件
//            file.save(progress: { (progress) in
//                print(progress)
//            }) { (result) in
//                switch result {
//                case .success:
//                    //保存完毕之后再进行文件信息的关联，关联到具体的用户信息上
//
//                    if let value = file.url?.value {
//                        print("文件保存完成。URL: \(value)")
//                    }
//                case .failure(error: let error):
//                    print(error)
//                }
//            }
//
//        }
        
        
        //本地文件上传，需要配置文件的访问域名。访问情况取决于当前域名的有效情况【推荐使用的上传方式】
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //添加完整存储路径信息
        let fileURL = documentsURL.appendingPathComponent("/\(audioDirectory)/downloadedAduio.mp3")
        
        let fileData = try? Data(contentsOf: fileURL)
        
        if fileData != nil{
            let file = LCFile(payload: .data(data: fileData!))
            file.save(progress: { (progress) in
                print(progress)
            }) { (result) in
                switch result {
                case .success:
                    //保存完毕之后再进行文件信息的关联，关联到具体的用户信息上
                    
                    if let value = file.url?.value {
                        print("文件保存完成。URL: \(value)")
                    }
                case .failure(error: let error):
                    print(error)
                }
            }
        }else{
            print("没有文件")
        }
        
    }
}
