//
//  FileView.swift
//  you
//  文件页面
//  Created by 翁益亨 on 2024/6/28.
//

import SwiftUI

struct FileView: View {
    //共享的数据获取【内含蓝牙管理内容】
    @EnvironmentObject var sharedData : SharedData
    
    @AppStorage("userScheme") var userTheme: Theme = .systemDefault

    @StateObject var fileModel = FileModel()
    
    //用来控制菜单栏的展示
    @Binding var isSidebarVisible : Bool
    
    //显示文件列表的来源信息【互相关联同步】
    @Binding var fileSource : FileSource
    
    
    var body: some View {
        
        VStack(spacing:10){
            Spacer().frame(height:10)
            
            HStack{
                NavigationLink(destination: ConnectBluetoothView()) {
                    Text(sharedData.selectedSensor != nil ? sharedData.selectedSensor!.name : "+连接蓝牙").foregroundColor(.black).bold().frame(width: 100,height: 30).background(.white).cornerRadius(5)
                }
                
                
                Spacer()
                
                Text("联系客服").frame(width: 100,height: 30).cornerRadius(5).onTapGesture {
                    
                }
            }
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment:.leading,spacing:10){
                    
                    
    //                Button("下载音频文件"){
    //                    AudioDownloadAPI.downloadAudio(downloadURL: "")
    //                }
    //
    //                Button("上传文件到LeanCloud"){
    //                    AudioDownloadAPI.uploadCloud()
    //                }
                    
                    //顶部文件数量描述
                    HStack{
                        //图片
                        Image("icon_menu")
                            .resizable()
                            .frame(width: 30,height: 30).onTapGesture {
                                
                                isSidebarVisible.toggle()
//                                修改全局的主题色
//                                if userTheme == .dark{
//                                    userTheme = .light
//                                }else{
//                                    userTheme = .dark
//                                }
                            }
                        //文本
                        Text(fileSource.title).font(.system(size: 24))
                            .bold()
                            .foregroundColor(.black)
                    }
                    Spacer().frame(height:2)
                    
                    //遍历数据源进行内容同步 【云端 + 本地】
                    ForEach(fileModel.fileOnCloudList,id: \.title) { item in
                        NavigationLink(destination: AudioWaveView(recordId: item.recordId)) {
                            FileItem(title: item.title, date: item.createdTime, time: item.duration, tag: item.labels  ?? [])
                        }
                    }
                    
                    //待同步的数据内容。不允许点击，显示在同步中。顶部进度处理
                    ForEach(fileModel.fileOnLocalList,id: \.title) { item in
//                        NavigationLink(destination: AudioWaveView(recordId: item.recordId)) {
//                            FileItem(title: item.title, date: item.createdTime, time: item.duration,tag: item.labels ?? [])
//                        }
                        
                        FileItem(title: item.title, date: item.createdTime, time: item.duration,tag: item.labels ?? [])
                    }
                    
                    
                    
                }
            }.overlay(alignment:.top,content: {
                //只有触发外设数据同步才会展示【蓝牙连接外设，外设发起请求json数据展示文件大小】
                if !fileModel.fileCacheList.isEmpty {
                    //当前的顶部展示下载中提示信息
                    HStack(spacing:10){
                        //同步的进度展示
                        //这里的多个任务必须要单个子线程队列同步记录，完成后通过队列循环来执行下一个
                        
                        ProgressIndicatorView(isVisible: $fileModel.showProgressIndicator, type: .bar(progress: $fileModel.progress, backgroundColor: .gray.opacity(0.25)))
                            .frame(height: 8.0)
                            .foregroundColor(.red)
                        
                        //所有下载文件的进度 1/2
                        Text("\(fileModel.finishSyncFile)/\(fileModel.fileCacheList.count)").font(.system(size: 12)).foregroundColor(.black)
                        
                        //当前每秒同步的文件大小【实际上是每次同步的bit】
                        Text("0 B/s").font(.system(size: 12)).foregroundColor(.black)
                        
                        //快传按钮，用于弹窗显示连接外设热点功能
                        Button{
                            FastTransmitPopup().showAndStack()
                        }label:{
                            Label {
                                Text("快传").font(.system(size:12))
                            } icon: {
                              Image(systemName: "arkit")
                            }.padding(.horizontal, 10)
                            .frame(maxWidth:80)
                            .frame(height: 30)
                            .background(.black)
                            .cornerRadius(15)
                        }
                        
                    }.padding(.horizontal, 15).frame(maxWidth:.infinity).frame(height:40)
                        //Color.cyan.opacity(0.4)
                        .background(          LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(4)
                }
               
            })
            .frame(maxWidth: .infinity)
            
            
            
        }
        //进度情况，时间间隔下载情况监测
        .onReceive(fileModel.timer) { _ in
            
            fileModel.progress = CGFloat(sharedData.receivedFileData.count)/(2196*20)
//            /fileModel.fileCacheList[0].fileSize.floatValue
//            guard fileModel.enableAutoProgress else { return }
//            ///进度同步
//            switch fileModel.progress {
//            case ...0.3, 0.4...0.6:
//                fileModel.progress += 1 / 30
//            case 0.3...0.4, 0.6...0.9:
//                fileModel.progress += 1 / 120
//            case 0.9...0.99:
//                fileModel.progress = 1
//            case 1.0...:
//                fileModel.progress = 0
//            default:
//                break
//            }


        }
        .onChange(of:sharedData.normalData,perform: { newValue in
            //同步的数据变化。这里统一清除本地添加的数据，再重新添加
            //这里是做单条数据的示例
            if let fileInformation:FileInformation = decodeJson(from: newValue!) {
                //这里的fileSize是用来判断是否完成了Data类型数据的传输，完成之后开始保存到本地文件内容
                print("fileName: \(fileInformation.fileName),fileCount:\(fileInformation.fileSize)")
                
                //下载状态添加
                fileModel.fileCacheList.append(fileInformation)
                
                let file : FileOnCloudData = .init(recordId: -1, title: fileInformation.fileName, createdTime: "2020-01-02", duration: "11m 20s", keywords: [], transferStatus: 0)
                
                //显示文件的数据源添加
                fileModel.fileOnLocalList.append(file)
            }
        })
        .onChange(of: fileModel.finishSyncFile, perform: { newValue in
            if newValue == fileModel.fileCacheList.count{
                //完成全部下载，清空下载数据源
                fileModel.fileCacheList.removeAll()
            }
        }).onChange(of: fileSource, perform: { newValue in
            //通过获取变化结果来驱动页面文件检索结果业务
            self.modifyFileCount(currentFileSource: newValue)
        })
        .onChange(of: fileModel.fileOnCloudList.count, perform: { newValue in
            print("newValue onCloud:\(newValue)")
            self.modifyFileCount(currentFileSource: fileSource)
        })
        .onChange(of: fileModel.fileOnLocalList.count, perform: { newValue in
            print("newValue onLocal:\(newValue)")
            self.modifyFileCount(currentFileSource: fileSource)
        })
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
        .background(Color(hexString: "#F6F7F8"))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .onAppear{
            //获取云端文件列表
            if fileModel.fileOnCloudList.isEmpty{
                fileModel.getFileDatabase()
                //蓝牙功能注册监听
                sharedData.bluejay.register(connectionObserver: sharedData)
                sharedData.bluejay.register(serviceObserver: sharedData)
            }

           

        }.onDisappear{

            //所有的页面切换都是先执行新页面的onAppear后再执行上个页面的onDisappear
            //取消状态监听的注册。由于外设的监听要贯穿整个APP，所以不需要取消注册的监听
//            sharedData.bluejay.unregister(connectionObserver: sharedData)
//            sharedData.bluejay.unregister(serviceObserver: sharedData)
        }
    }
    
    
    //MARK: - 监听数据源赋值
    private func modifyFileCount(currentFileSource: FileSource){
        print("-----:\(fileModel.fileOnCloudList.count+fileModel.fileOnLocalList.count)")
        if currentFileSource.type == 1 {
            fileSource = .ALLFILES(count: fileModel.fileOnCloudList.count + fileModel.fileOnLocalList.count)
        }else if currentFileSource.type == 2{
            fileSource = .UNCLASSIFIED(count: fileModel.fileOnCloudList.count + fileModel.fileOnLocalList.count)
        }
    }
    
}

//struct FileView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileView()
//    }
//}

//MARK: - 列表中显示的文件信息
struct FileItem : View{
    let title : String
    let date : String
    let time : String
    let tag : [FileLabelData]
    
    var body: some View{
        VStack(alignment:.leading,spacing: 7){
            Text(title)
                .bold()
                .foregroundColor(.black)
                .font(.system(size: 22))
            
            HStack(spacing:20){
                //日期
                Label{
                    Text(date)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hexString: "#dbdbdb"))
                }icon: {
                    Image("icon_calendar")
                        .resizable()
                        .frame(width:14, height: 14)
                }
                //时间内容
                
                Label{
                    Text(time)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hexString: "#dbdbdb"))
                }icon: {
                    Image("icon_clock")
                        .resizable()
                        .frame(width:14, height: 14)
                }
            }
            
            //底部标签Tag，存在时才进行赋值
            if tag.isNotEmpty{
                HStack{
                    ForEach(tag,id: \.labelName) { item in
                        Text(item.labelName)
                            .foregroundColor(Color(hexString: item.labelColor))
                            .frame(width: 40,height: 17)
                            .background(Color(hexString: "#E9E9E9"))
                            .cornerRadius(2)
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
        .background(.white)
        .cornerRadius(10)
    }
}
