//
//  FileView.swift
//  you
//  文件页面
//  Created by 翁益亨 on 2024/6/28.
//

import SwiftUI

struct FileView: View {
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
                    Text("+连接蓝牙").foregroundColor(.black).bold().frame(width: 100,height: 30).background(.white).cornerRadius(5)
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
                    
                    ForEach(fileModel.fileOnLocalList,id: \.title) { item in
                        NavigationLink(destination: AudioWaveView(recordId: item.recordId)) {
                            FileItem(title: item.title, date: item.createdTime, time: item.duration,tag: item.labels ?? [])
                        }
                    }
                    
                }
            }
            .frame(maxWidth: .infinity)
            
            
            
        }.onChange(of: fileSource, perform: { newValue in
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
//        .background(Color(hexString: "#F6F7F8"))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .onAppear{
            //获取云端文件列表
            print("fileModel.fileOnCloudList.isEmpty:\(fileModel.fileOnCloudList.isEmpty)")
            print(fileModel.fileOnCloudList)
            if fileModel.fileOnCloudList.isEmpty{
                fileModel.getFileDatabase()
            }
            
//            FastTransmitPopup().showAndStack()
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
