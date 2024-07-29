//
//  AudioWaveView.swift
//  you
//
//  Created by 翁益亨 on 2024/7/5.
//

import SwiftUI
import Waveform

struct AudioWaveView: View {
    @StateObject var model = FileDetailModel()
    
    var currentTimeText: String {
        let currentTime = String(format: "%.1f", model.conductor!.timeStamp)
        let endTime = String(format: "%.1f", model.conductor!.endTime)
        return currentTime + " of " + endTime
    }
    
    @State var start = 0.0
   
    //圆角内容同步
    @State var indicatorSize = 10.0
    
    //同步传递的recordId，用于获取详情信息
    var recordId : Int
    
    init(recordId: Int){
        self.recordId = recordId
    }

    
    var body: some View {
        if model.fileOnCloudDetailData == nil{
            VStack{
                
            }.navigationBarHidden(true)
            .onAppear{
                //界面显示的时候进行网络请求获取数据
                model.getRecordDetail(recordId)
            }
        }else{
            VStack{
                ZStack(alignment: .leading) {
                    //设置的背景颜色
                    RoundedRectangle(cornerRadius: indicatorSize).foregroundColor(.white)
                    //音频波形图
                    Waveform(samples: model.waveModel!.samples).foregroundColor(.cyan)
                        .padding(.vertical, 5)
                       
                        
                    //覆盖上方的阴影。需要同步当前的进度以及对应的结果时长用来做比例移动
                    MinimapView(start: $start, length: model.length,indicatorSize: $indicatorSize)
                }.frame(height: 100)
                .padding()
                
                //控制音频文件的播放、倍速等操作 【AI降噪暂不处理】
               
                
                Text("currentTimeText:\(currentTimeText)")
                
                
                HStack{
                    Button {
                        //固定设置倍速为2
                        model.conductor!.rate = 1.25
                    } label: {
                        Image("icon_audio_speed")
                            .resizable()
                            .frame(width: 40,height:40)
                    }.frame(maxWidth: .infinity)

                    Button {
                        //.seek内部实现逻辑是回退超过音频的0秒会自动暂停
                        //可以获取当前的播放位置来判断-15秒后是否小于0，如果小于0直接seek当前播放时长
                        var duration = 15.0
                        
                        //currentTime表示播放的进度时长
                        if model.conductor!.player.currentTime < duration {
                            duration = model.conductor!.player.currentTime
                            print("duration::\(duration)")
                        }
                        
                        if !model.conductor!.isPlaying{
                            model.conductor!.isPlaying = true
                        }
                        //开始时间必须大于0.所以这里使用0.01做一个兼容值
                        model.conductor!.player.seek(time: -(duration-0.01))
                        
                    } label: {
                        Image("icon_fast_rewind")
                            .resizable()
                            .frame(width: 40,height:40)
                    }.frame(maxWidth: .infinity)
                    
                    
                    Button {
                        //conductor播放器功能是全局的，需要在页面销毁时暂停/销毁
                        
                        if model.conductor!.player.status == .playing{
                            //在播放中，提供暂停操作
                            model.conductor!.isPlaying = false
                        }else if model.conductor!.player.status == .paused || model.conductor!.player.status == .stopped{
                            //暂停后恢复
                            model.conductor!.isPlaying = true
                        }
                        
                    } label: {
                        Image(model.conductor!.isPlaying ? "icon_pause_operate":"icon_play_operate")
                            .resizable()
                            .frame(width: 40,height:40)
                    }.frame(maxWidth: .infinity)
                    
               
                    Button {
                        //内部实现逻辑是回退超过0秒会自动暂停
                        if !model.conductor!.isPlaying{
                            model.conductor!.isPlaying = true
                        }
                        //超出最终播放的时长也会暂停内容。这里添加业务逻辑，超出后定位到0显示【重新播放逻辑】
                        model.conductor!.player.seek(time: 15)
                    } label: {
                        Image("icon_fast_forward")
                            .resizable()
                            .frame(width: 40,height:40)
                    }.frame(maxWidth: .infinity)
                    
                    
                    Button {
                        //AI降噪功能
                    } label: {
                        Image("icon_noise_reduction")
                            .resizable()
                            .frame(width: 40,height:40)
                    }.frame(maxWidth: .infinity)
                }
                
                
                //语音转文本的所有信息
                AudioConvertTextView()
                    .frame(maxHeight: .infinity)
            }.navigationBarHidden(true)
        }
        
    }
}

struct AudioWaveView_Previews: PreviewProvider {
    static var previews: some View {
        AudioWaveView(recordId: 1)
    }
}
