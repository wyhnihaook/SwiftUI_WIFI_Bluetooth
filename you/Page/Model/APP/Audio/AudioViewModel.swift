//
//  AudioViewModel.swift
//  you
//  依赖于Waveform进行的
//  Created by 翁益亨 on 2024/7/4.
//

import AVFoundation
import Combine
import Waveform

final class AudioViewModel: ObservableObject {
    var samples: SampleBuffer

    init(file: AVAudioFile) {
        let stereo = file.floatChannelData()!
        samples = SampleBuffer(samples: stereo[0])
    }
    
    
    //获取本地文件
    static func getFile(fileName:String, fileExtension:String) -> AVAudioFile {
//        let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension)!
        //获取本地的测试内容
        var directoryPath = FileUtil.getAudioDirectory(path: audioDirectory)
        directoryPath.append("/测试Test.mp3")
        
        return try! AVAudioFile(forReading: URL(fileURLWithPath: directoryPath))
    }
    
    //注意⚠️：无法获取网络文件 - 只能通过本地的音频扫描才能一次性加载全部的轨迹
    static func getLocalFile(localUrl: URL) -> AVAudioFile {
        return try! AVAudioFile(forReading:localUrl)
    }
    
}

