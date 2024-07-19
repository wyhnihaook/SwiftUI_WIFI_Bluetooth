//
//  ContentView.swift
//  you
//
//  Created by 翁益亨 on 2024/6/25.
//

import SwiftUI


struct ContentView: View {
    //必须要创建关联界面的持久化存储内容声明，可以不添加language的信息
    @EnvironmentObject var sharedData : SharedData

    var body: some View {
        NavigationView{
            List{
                //这里要实践，应用内切后语言的效果
                Text("result".localized())
                //全局任何地方修改都会引起引用到视图变化
                Text("with params:%@".localizedWithParam(args: ["result".localized()]))

                //设置分节内容
                Section("WIFI功能") {
                    NavigationLink(destination: WiFiView()) {
                        PageRow(title: "WIFI相关", subTitle: "提供查找、记录并自动连接的功能")
                    }
                }
                
                Section("蓝牙功能") {
                    NavigationLink(destination: BluetoothView()) {
                        PageRow(title: "蓝牙相关", subTitle: "提供查找、连接、通信、记录并自动连接的功能")
                    }
                }
                
                Section("Apple Pay") {
                    NavigationLink(destination: ApplePayView()) {
                        PageRow(title: "Apple Pay", subTitle: "内部支付")
                    }
                }
                
                Section("LeanCloud") {
                    NavigationLink(destination: LeanCloudView()) {
                        PageRow(title: "云服务", subTitle: "功能测试")
                    }
                }
                
                Section("页面展示") {
                    NavigationLink(destination: OtherView()) {
                        PageRow(title: "静态页面", subTitle: "静态APP内容")
                    }
                }
            }
            //设置分组模式，默认适配模式根据内容加载
            .listStyle(.grouped)
            //提供列表的大标题信息
            .navigationBarTitle(Text("示例"), displayMode: .large)
            .navigationBarItems(leading: Text("Left").navBarTextStyle(color:.blue), trailing: Text("Right").navBarTextStyle())
        }.onAppear{
            print("系统语言：\(String.getCurrentLanguage())")
        }
    }
}

extension String{
//    func localized(comment: String = "") -> String{
//        return NSLocalizedString(self, comment: comment)
//    }
    
    //获取当前【系统】的语言类型
    static func getCurrentLanguage() -> String{
        let preferredLang : String = Bundle.main.preferredLocalizations.first! as String
        
        switch preferredLang{
            case "en-US", "en-CN":
                return "en"//英文
            case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
                return "cn"//中文
                
            default:
                return ""
        }
    }

    //国际化携带参数添加【这里的参数直接添加，不做其他操作，如果也需要兼容国际化就在参数设置时就进行转化】
    //主要是通过占位符进行设置。其中comment是给翻译者的注释，描述上下文
    func localizedWithParam(args: [String]) -> String{
        return String(format: self.localized(), arguments: args)
    }
    
    func localized() -> String {
        return localized(using: nil)
    }

    
    func localized(using tableName: String?) -> String {
        //传递的是语言
        //当前项目文件夹查看：zh-Hans/中文 en/英文
        
        //从当前的缓存数据中获取需要展示的语言类型
        var currentLanguage = UserDefaults.standard.object(forKey: "language") as? String
        
        //默认首先获取对应的语言。如果不存在就默认跟随系统
        if currentLanguage == nil{
            currentLanguage = "en"
        }
        print("currentLanguage:\(String(describing: currentLanguage))")
        
        //这里要额外判断是否存在对应的语言，如果不存在兜底语言内容
        let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        //请保证切换到语言一定存在，从文件夹查找.
        //tableName当多语言适配创建多个文件来标识文本、按钮等时要传入tableName为自定义的额外的名称。默认情况下传递nil
        return bundle!.localizedString(forKey: self, value: nil, table: tableName)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
