//
//  ResultView.swift
//  you
//  结果显示页面
//  Created by 翁益亨 on 2024/7/24.
//

import SwiftUI

struct ResultData{
    let title : String
    
    let desc : String
    
    //占位的图片信息
    let image : String
    
    //占位的图片信息
    let width : Double
    let height : Double
    
    //文本内容点击区域显示
    let confirm : String
    
    init(_ title: String, desc: String,image: String, confirm: String = "", width: Double = 150, height: Double = 150) {
        self.title = title
        self.desc = desc
        self.image = image
        self.confirm = confirm
        self.width = width
        self.height = height
    }
}

//当前展示的页面类型
enum PageType{
    //注册/忘记密码 账户相关页面跳转
    case Account(data : ResultData)
    
    var data : ResultData{
        switch self{
            case .Account(let info) : return info
        }
    }
}

struct ResultView: View {
    @EnvironmentObject private var navigationStack: NavigationStackCompat

    //展示类型
    var pageType : PageType
    
    //添加跳转页面的会调
    var callback : ()->Void
    
    init(pageType: PageType,  callback: @escaping ()->Void){
        self.pageType = pageType
        self.callback = callback
    }
    
    
    var body: some View {

        NavigationBody(title: pageType.data.title) {
            
        } content: {
            VStack{
                
                //图片占位
                Image(pageType.data.image).resizable().frame(width: pageType.data.width, height: pageType.data.height)
                
                Spacer().frame(height: 40)
            
                Text(pageType.data.desc).foregroundColor(.black).font(.system(size: 16))
                
                Spacer().frame(height: 80)

                Button{
                    navigationStack.pop(to:.view(withId: PageID.loginID))

                }label: {
                    Text(pageType.data.confirm).foregroundColor(.white).frame(width: 250,height: 50)
                        .background(.blue).cornerRadius(25)
                }
                
            }
        } backCallback: {
            navigationStack.pop(to:.view(withId: PageID.loginID))
        }

        
        
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(pageType: .Account(data: ResultData("",desc: "",image: "completed"))) {
            
        }
    }
}
