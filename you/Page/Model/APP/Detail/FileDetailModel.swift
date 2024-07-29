//
//  FileDetailModel.swift
//  you
//
//  Created by 翁益亨 on 2024/7/29.
//

import Foundation
import LeanCloud

class FileDetailModel : ObservableObject{
    //网络数据详情同步
    @Published var fileOnCloudDetailData:FileOnCloudDetailData?
    
    @Published var conductor : AudioCompletionHandlerConductor?
    
    //需要外界同步而来当前的播放进度
    var length :Double{
        if conductor!.endTime == 0{
            return 0
        }
        return conductor!.timeStamp/conductor!.endTime
    }
    //波形图显示控件
    @Published var waveModel : AudioViewModel?

    
    //MARK: - 获取音频详情的信息
    func getRecordDetail(_ id: Int){
        let query = LCQuery(className: fileDetail)
        query.whereKey(recordId, .equalTo(id))
        _ = query.find { result in
            switch result {
            case .success(objects: let details):
                //直接根据条件查询返回的是数组，这里固定获取第一条数据
                if details.isNotEmpty{
                    var item = details.first!
                    print(item.jsonValue)
                    ///数据处理转化
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
                                
                                self.getTransferData(item) { results in
                                    if results != nil{
                                        do{
                                            try item.set("transferList", value: results)
                                        }catch{
                                            print("file List transferList error:\(error)")
                                        }
                                    }
                                    self.convertDatabase(item)
                                }
                                
                                
                            case .failure(error: let error):
                                print(error)
                            }
                        }
                    }else{
                        self.getTransferData(item){ results in
                            if results != nil{
                                do{
                                    try item.set("transferList", value: results)
                                }catch{
                                    print("file List transferList error:\(error)")
                                }
                            }
                            self.convertDatabase(item)
                        }
                    }

                }
                
            case .failure(error: let error):
                print(error)
            }
        }
    }
    
    
    //MARK: - 转写记录获取
    private func getTransferData(_ item : LCObject, callback:@escaping ([LCObject]?)->Void){
        let transferList = item.get("transferList") as! LCArray

        ///获取数据库数据都为异步操作，所以这里要处理分情况处理
        if !transferList.isEmpty{
            var transferObjectIds:[String] = []

            let queryTransfer = LCQuery(className: fileTransfer)
                        
            for transfer in transferList{
                transferObjectIds.append((transfer as! LCObject).objectId!.value)
            }
            
            //containedIn数组中满足一个就会返回
            //containedAllIn数组中所有条件都需要满足
            queryTransfer.whereKey("objectId", .containedIn(transferObjectIds))
            queryTransfer.find { result in
                switch result {
                case .success(objects: let transferObjectInfos):
                    //满足的内容。替换数据源
                    callback(transferObjectInfos)
                case .failure(error: let error):
                    print(error)
                }
            }
        }else{
            callback(nil)
        }
        
    }
    
    ///文件内容转化
    private func convertDatabase(_ item: LCObject){
        if let fileOnCloudDetailData:FileOnCloudDetailData =  decodeMap(from: item.jsonValue as! [String : Any]){
            //初始化对应的视图操作对象
            //获取文件信息后根据后缀进行文件的本地存储。完成后，才进行页面上的渲染【目前使用固定格式mp3文件进行存储】
            let fileUrl = fileOnCloudDetailData.fileUrl
            
            //文件的命名规则：用最后的路径信息作为唯一标识
            let fileName = URL(string: fileUrl)?.lastPathComponent ?? "test"
            
            print("fileName:\(fileName)")
            
            AudioDownloadAPI.downloadAudio(downloadURL: fileUrl, fileName: fileName) { url in
                if url != nil{
                    //下载成功
                    self.conductor = AudioCompletionHandlerConductor(localUrl: url!)
                    self.waveModel = AudioViewModel(file: AudioViewModel.getLocalFile(localUrl: url!))
                    
                    //存在数据的情况，渲染在页面上
                    self.fileOnCloudDetailData = fileOnCloudDetailData
                }else{
                    //下载失败处理情况
                }
            }
            
            
        }
    }

}
