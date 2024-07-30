//
//  FileDetailModel.swift
//  you
//  【对于ObservableObject的实现类不能嵌套ObservableObject的实现类，会导致内部通信的数据失效】
//  请保持一个ObservableObject对应一个View的完整生命周期
//  Created by 翁益亨 on 2024/7/29.
//

import AudioKit
import Foundation
import LeanCloud
import AVFoundation
import Combine
import Waveform

class FileDetailModel : ObservableObject, HasAudioEngine{
    //网络数据详情同步
    @Published var fileOnCloudDetailData:FileOnCloudDetailData?
    
    //波形图相关内容初始化
    var samples: SampleBuffer?
    
    //音频控制器
    //初始化时同步的数据
    var fileUrl : URL?
    
    let engine = AudioEngine()
    var player = AudioPlayer()
    var fileURL = [URL]()

    //控制倍速
    var variSpeed: VariSpeed?
    
    //定时任务，用来同步播放进度
    var timer: Timer!
    //获取当前开始的时间节点，用来计算真实的进度
    var timePrevious: TimeInterval = .init(DispatchTime.now().uptimeNanoseconds) / 1_000_000_000

    
    @Published var playDuration = 0.0
    @Published var endTime: TimeInterval = 0

    @Published var _timeStamp: TimeInterval = 0
    var timeStamp: TimeInterval {
        get {
            return _timeStamp
        }
        set {
            //限定_timeStamp 的 值在0到endTime之间
            _timeStamp = customClamp(newValue, in: 0 ... endTime)
            
            //表示播放完毕了，当前的播放时长定位到0秒开始
            if newValue > endTime {
                isPlaying = false
                _timeStamp = 0
            }
        }
    }

    //当前倍速控制
    @Published var rate: AUValue = 1.0 {
        didSet {
            variSpeed!.rate = rate
        }
    }
    //播放状态同步。这里只是处理播放和暂停操作
    //需要注意：暂停情况进行seek跳转的时候会自动播放
    @Published var isPlaying: Bool = false {
        didSet {
            //通过操作数据源引起界面和业务信息变化。设置播放并且当前是暂停情况，就进行初始化
            if isPlaying && player.status == .stopped{
                //首先判断当前的播放状态是暂停的情况，就进行第一次初始化处理
                timePrevious = TimeInterval(DispatchTime.now().uptimeNanoseconds) / 1_000_000_000
                print("timePrevious:\(timePrevious)")
                startPlaying()
                return
            }
            
            //当前不在播放，就设置暂停
            if !isPlaying && player.status == .playing{
                player.pause()
            } else if isPlaying && player.status == .paused{
                //这里是用来兼容处理暂停状态的。因为seek后会自动播放，所以要如果不是暂停就不需要播放
                timePrevious = TimeInterval(DispatchTime.now().uptimeNanoseconds) / 1_000_000_000

                player.resume()
            }
        }
    }
    
    var currentFileIndex = 0


    
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
                    self.initWaveView(file:  AudioViewModel.getLocalFile(localUrl: url!))
                    self.initAudioController(localUrl: url!)

                    //存在数据的情况，渲染在页面上
                    self.fileOnCloudDetailData = fileOnCloudDetailData
                }else{
                    //下载失败处理情况
                }
            }
            
            
        }
    }
    
    
    //MARK: - 初始化波形图加载对象
    private func initWaveView(file: AVAudioFile) {
        let stereo = file.floatChannelData()!
        samples = SampleBuffer(samples: stereo[0])
    }
    
    private func getLocalFile(localUrl: URL) -> AVAudioFile {
        return try! AVAudioFile(forReading:localUrl)
    }
    
    //MARK: - 音频控制
    private func initAudioController(localUrl: URL){
        fileUrl = localUrl
        fileURL.append(fileUrl!)

        variSpeed = VariSpeed(player)
        variSpeed!.rate = rate

        engine.output = variSpeed

        /* Assign the function
         to the completion handler */
        player.completionHandler = playEnded
        //初始化直接开始初始化AVAudioEngine
        //启动音频引擎用于获取音频等播放进度等信息
        
        start()
        
        //初始化定时器
        timer = Timer.scheduledTimer(timeInterval: 0.05,
                                     target: self,
                                     selector: #selector(checkTime),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func playEnded() {
        //播放结束不做任何处理内部状态会流转
    }
    
    @objc func checkTime() {
        if isPlaying {
            let timeNow = TimeInterval(DispatchTime.now().uptimeNanoseconds) / 1_000_000_000
            //timeStamp 累加当前的数据状态。(timeNow - timePrevious)实际上是每次0.05执行一次间隔，结果：0.05左右
            timeStamp += (timeNow - timePrevious)

            timePrevious = timeNow
        }
    }

    func startPlaying() {
        try? player.load(url: fileURL[currentFileIndex])
        //初始化当前的结束时间。用来同步百分比数据。必须在播放器加载了具体的url之后才能去
        endTime = player.duration
                
        player.play()
        
        if let duration = player.file?.duration {
            playDuration = duration
        }
        
    }
    
    
    func customClamp<T: Comparable>(_ value: T, in range: ClosedRange<T>) -> T {
        return max(range.lowerBound, min(range.upperBound, value))
    }


}
