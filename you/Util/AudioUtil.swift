//
//  AudioUtil.swift
//  you
//  音频帮助类
//  Created by 翁益亨 on 2024/7/4.
//

import Foundation
import AudioUnit

struct WSASBD {
    /// 声道数
    var channels: UInt32 = 1
    /// 采样率：
    var sampleRate: Double = 48000
    /// 位深
    var mBitsPerChannel: UInt32 = 16
}

func getAudioStreamBasicDescription(des: WSASBD, isInterleaved: Bool) -> AudioStreamBasicDescription {
    var asbd = AudioStreamBasicDescription()
    let bytesPerSample = des.mBitsPerChannel / 8
    asbd.mChannelsPerFrame = des.channels
    asbd.mBitsPerChannel = 8 * bytesPerSample
    asbd.mBytesPerFrame = des.channels * bytesPerSample
    asbd.mFramesPerPacket = 1
    asbd.mBytesPerPacket = des.channels * bytesPerSample
    if isInterleaved {
        asbd.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked
    } else {
        asbd.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked
    }
    asbd.mFormatID = kAudioFormatLinearPCM
    asbd.mSampleRate = des.sampleRate
    asbd.mReserved = 0
    return asbd
}



func bridge<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
    return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}

func bridge<T: AnyObject>(obj: T) -> UnsafeRawPointer {
    return UnsafeRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}


class ZGAudioDataBuffer {
    
    private var buffer = Data()
    private var startIndex = 0
    private let lock = NSLock()

    func appendData(data: Data) {
        lock.lock()
        defer { lock.unlock() }
        buffer.append(data)
       //控制缓冲区最大长度
        let cacheLen = 1024*1024*5
        if buffer.count > cacheLen {
            let excessLength = buffer.count - cacheLen
            startIndex -= excessLength
            buffer = buffer.subdata(in: excessLength..<buffer.count)
        }
    }

    func getData(len: Int) -> Data {
        
        lock.lock()
        defer { lock.unlock() }
        
        guard len > 0 else {
            return Data(repeating: 0, count: len)
        }

        let availableLength = buffer.count - startIndex
        if availableLength <= 0 {
            return Data(repeating: 0, count: len)
        }

        let actualLength = min(len, availableLength)
        var data = buffer.subdata(in: startIndex..<startIndex+actualLength)
        startIndex += actualLength
        if data.count < len {
            data.append(Data(repeating: 0, count: len-data.count))
        }
        return data
    }
    
    func clear(){
        lock.lock()
        defer { lock.unlock() }
        buffer.removeAll()
        startIndex = 0
    }
}
