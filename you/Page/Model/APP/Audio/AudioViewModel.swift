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
        let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension)!
        return try! AVAudioFile(forReading: url)
    }

}

