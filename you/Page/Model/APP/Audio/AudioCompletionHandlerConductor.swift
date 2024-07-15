//
//  AudioCompletionHandlerConductor.swift
//  you
//  音频播放器控制类
//  Created by 翁益亨 on 2024/7/5.
//

import AudioKit
import AVFoundation
import SwiftUI

class AudioCompletionHandlerConductor: ObservableObject, HasAudioEngine {
    let engine = AudioEngine()
    var player = AudioPlayer()
    var fileURL = [URL]()

    //控制倍速
    let variSpeed: VariSpeed
    
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
            variSpeed.rate = rate
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

    // Load the files to play
    func getPlayerFiles() {
        let files = ["test.mp3"]
        for filename in files {
//            let url = Bundle.main.url(forResource: "test", withExtension: "mp3")!
            var directoryPath = FileUtil.getAudioDirectory(path: audioDirectory)
            directoryPath.append("/测试Test.mp3")
            fileURL.append(URL(fileURLWithPath: directoryPath))
//            fileURL.append(url)
        }
    }

  
    func playEnded() {
        //播放结束不做任何处理内部状态会流转
    }

    init() {
        
        variSpeed = VariSpeed(player)
        variSpeed.rate = rate
        
        getPlayerFiles()
        engine.output = variSpeed
//        engine.output = player

        /* Assign the function
         to the completion handler */
        player.completionHandler = playEnded
        //初始化直接开始初始化AVAudioEngine
        //启动音频引擎用于获取音频等播放进度等信息
        
        start()
        
        print("timePrevious:\(timePrevious)")

        //初始化定时器
        timer = Timer.scheduledTimer(timeInterval: 0.05,
                                     target: self,
                                     selector: #selector(checkTime),
                                     userInfo: nil,
                                     repeats: true)
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

}

func customClamp<T: Comparable>(_ value: T, in range: ClosedRange<T>) -> T {
    return max(range.lowerBound, min(range.upperBound, value))
}
