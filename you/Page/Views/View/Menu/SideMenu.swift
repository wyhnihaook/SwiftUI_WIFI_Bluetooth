//
//  Sidebar.swift
//  you
//
//  Created by 翁益亨 on 2024/8/2.
//

import SwiftUI

//文件来源展示
public enum FileSource{
    
    case ALLFILES(count: Int)
    case UNCLASSIFIED(count: Int)
    case RECYCLEBIN
    case CALL
    case NOTE
    case IMPORT
    
    var type : Int{
        switch self{
            case .ALLFILES : return 1
            case .UNCLASSIFIED : return 2
            case .RECYCLEBIN : return 3
            case .CALL : return 4
            case .NOTE : return 5
            case .IMPORT : return 6
        }
    }
    
    var title : String{
        switch self{
            case .ALLFILES(let count) : return "全部文件(\(count))"
            case .UNCLASSIFIED(let count) : return "未分类(\(count))"
            case .RECYCLEBIN : return "回收站"
            case .CALL : return "CALL"
            case .NOTE : return "NOTE"
            case .IMPORT : return "IMPORT"
        }
    }
    
    var icon : String{
        switch self{
            case .ALLFILES : return "house"
            case .UNCLASSIFIED : return "heart"
            case .RECYCLEBIN : return "arkit"
            default : return ""
        }
    }
    
    
}

// 实现 Equatable 协议，使枚举支持比较【能使用onChange监听】
extension FileSource: Equatable {
    public static func == (lhs: FileSource, rhs: FileSource) -> Bool {
        return lhs.type == rhs.type
    }
}



struct SideMenu: View {
    
    //页面中的展示的顶部内容【这里的数据要在页面初始化后同步】
    var fileSourseTypeList : [FileSource] = [.ALLFILES(count: 0),.UNCLASSIFIED(count: 0),.RECYCLEBIN]
    
    var fileTagTypeList : [FileSource] = [.CALL, .NOTE, .IMPORT]
    
    //外部传递同步的状态
    @Binding var isSidebarVisible : Bool
    
    //文件信息来源 文件夹、未分类、回收站。CALL、NOTE、IMPORT。 - 需要关联外部状态
    //默认：全部文件【ALLFILES】
    @Binding var fileSource : FileSource
    
    
    //排序方式。修改时间倒序正序 、 创建时间倒序正序
    
    
    
    //抽屉的最大展示的宽度设置
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.7
    
    //抽屉背景色设置
    var bgColor: Color =
           Color(.init(
                   red: 255 / 255,
                   green: 255 / 255,
                   blue: 255 / 255,
                   alpha: 1))

    
    var body: some View {
        ZStack {
               GeometryReader { _ in
                   EmptyView()
               }
               .background(.black.opacity(0.6))
               .opacity(isSidebarVisible ? 1 : 0)
                //设置状态变化时候的，页面过渡动画效果
               .animation(.easeInOut.delay(0.2), value: isSidebarVisible)
               .onTapGesture {
                   isSidebarVisible.toggle()
               }
            
            
                content

           }
            //忽略安全距离，撑满全屏。设置后，内部的子视图无法通过GeometryReader来获取安全距离
           .edgesIgnoringSafeArea(.all)

    }
    
    
    //具体展示内容
    var content: some View {
           HStack(alignment: .top) {
               ZStack(alignment: .top) {
                   bgColor
                   
                   ScrollView(showsIndicators:false){
                       VStack(spacing:0){
                           //顶部安全距离设置

                           Spacer.height(Screen.safeArea.top)
                           
                           //搜索提示
                           NavigationLink(destination: FileSearchView()) {
                               Label {
                                   Text("在所有文件中搜索").font(.system(size:14)).frame(maxWidth:.infinity,alignment: .leading)
                               } icon: {
                                 Image(systemName: "arkit")
                               }.padding(.horizontal, 10)
                               .frame(maxWidth:.infinity)
                               .frame(height: 30)
                               .background(Color(hexString: "#F6F7F9"))
                               .cornerRadius(3)
                           }
                           
                           //文件来源
                           Group{
                               ForEach(fileSourseTypeList,id:\.title){
                                   source in
                                   Spacer.height(10)
                                   FileSourceView(fileSource: source, checkFileSource: $fileSource)
                               }
                               
                               Spacer.height(10)
                               Divider().background(Color(hexString: "#E9E9E9"))
                           }
                           
                           
                           //创建文件夹功能
                           HStack{
                               Text("文件夹").bold().frame(maxWidth: .infinity,alignment: .leading)
                               
                               Image(systemName: "house")
                           }.frame(height:40).padding(.leading,10)
                           
                           //标签来源
                           Group{
                               ForEach(fileTagTypeList,id:\.title){
                                   source in
                                   Spacer.height(10)
                                   FileSourceView(fileSource: source, checkFileSource: $fileSource)
                               }
                               
                               Spacer.height(20)
                           }
                           
                           //排序方式
                           HStack{
                               Text("创建时间").frame(maxWidth: .infinity,alignment: .leading)
                               
                               Image(systemName: "house")
                           }.frame(height:40).padding(.leading,10)
                           
                           HStack{
                               Text("修改时间").frame(maxWidth: .infinity,alignment: .leading)
                               
                               Image(systemName: "house")
                           }.frame(height:40).padding(.leading,10)
                           
                           
                       }.padding(15)
                   }
               }
               .frame(width: sideBarWidth)
               .offset(x: isSidebarVisible ? 0 : -sideBarWidth)
               .animation(.default, value: isSidebarVisible)

               Spacer()
           }
       }
}

//struct Sidebar_Previews: PreviewProvider {
//    static var previews: some View {
//        SideMenu()
//    }
//}

//文件来源展示
struct FileSourceView : View{
    
    let fileSource : FileSource
    
    @Binding var checkFileSource : FileSource
    
    var body: some View{
        Group{
            //直接在if else 结尾处添加共有属性会提示不存在，所以使用Group包裹一层处理
            if fileSource.icon.isEmpty{
                Text(fileSource.type == checkFileSource.type ? checkFileSource.title : fileSource.title).font(.system(size:14)).frame(maxWidth:.infinity,alignment: .leading)
            }else{
                Label {
                    Text(fileSource.type == checkFileSource.type ? checkFileSource.title :fileSource.title).font(.system(size:14)).frame(maxWidth:.infinity,alignment: .leading)
                } icon: {
                    Image(systemName: fileSource.icon)
                }
            }
        }
        .padding(.horizontal,10)
        .frame(height: 40)
        //选中是高亮背景色
        .background(fileSource.type == checkFileSource.type ? .blue : .clear)
        .cornerRadius(3).onTapGesture {
            checkFileSource = fileSource
        }
    }
}
