//
//  UserInfoView.swift
//  you
//  用户基本信息页面【账号和资料】
//  Created by 翁益亨 on 2024/7/2.
//

import SwiftUI

struct UserInfoView: View {
    
    //激活登录状态
    @State private var isLinkLoginActive = false
    
    var body: some View {
        //外部NavigationLink跳转到一个新的导航器，内容全部自定义
        VStack(spacing:0){
            Spacer().frame(height: 10)
               
            //头像更换
            ZStack(alignment:.bottomTrailing){
                Image("icon_head_default")
                    .resizable()
                    .frame(width: 80, height: 80)
                
                Image("icon_camera")
                    .resizable()
                    .frame(width: 22, height: 22)
            }.frame(height: 100)
            
            Spacer().frame(height: 10)
            
            //基本信息
            Group{
                AccountLabel(title: "昵称", desc: "nihao"){
                    print("跳转昵称")
                }
                AccountLabel(title: "邮箱", desc: "www.baidu.com",canOperate: false)
                AccountLabel(title: "更改密码"){
                    print("更改密码")
                }
                AccountLabel(title: "设备"){
                    print("设备")
                }
            }
            
            Spacer().frame(height: 30)
            
            //退出功能按钮
            NavigationLink(
                destination: LoginView(),isActive: $isLinkLoginActive) {
                Button{
                    print("退出登录")
                    //跳转完成之后会被重置成false未激活
                    isLinkLoginActive = true
                }label: {
                    Text("退出登录").font(.system(size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height:50)
                        .background(Color(hexString: "#E9E9E9"))
                        .cornerRadius(12)
                }
            }
            
            
            Spacer()
            
            
            //删除功能按钮
            Button{
                print("删除账号")
            }label: {
                Text("删除账号").font(.system(size: 16))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height:50)
                    .background(Color(hexString: "#E9E9E9"))
                    .cornerRadius(12)
            }
    
            
            //提示信息
            HStack{
                Text("警告：").font(.system(size: 12))
                    .foregroundColor(.red)
                Text("您的账号信息和所有文件将永久删除").font(.system(size: 12))
                    .foregroundColor(.gray)
            }.padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 0))
        }
        .padding(15)
        .background(.white)
        //隐藏导航配置顶部信息
        .navigationBarHidden(true)
     
        
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}


//显示标签内容
struct AccountLabel : View{
    //标题信息
    let title : String
    //内容描述。默认空字符串
    let desc : String
    //点击事件。存在时展示箭头内容
    let canOperate : Bool
    //点击方法
    let clickCallBack : (() -> Void)
    
    init(title: String, desc: String = "", canOperate:Bool = true, clickCallBack: @escaping () -> Void = {}) {
        self.title = title
        self.desc = desc
        self.canOperate = canOperate
        self.clickCallBack = clickCallBack
    }
    
    var body: some View{
        VStack(spacing:0){
            HStack{
                
                Text(title)
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                
                //默认不会响应布局分发的点击事件，特殊的扩展布局->设置背景色后可响应.不能设置透明！！！
                Spacer()
                
                
                
                //额外信息
                if !desc.isEmpty{
                    
                    Text(desc)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                
                
                //箭头
                if canOperate{
                    Spacer().frame(width: 4)
                    Image("icon_arrow").resizable().frame(width:11, height: 11)
                }
                
            }.frame(height: 50)
            
            Divider().background(Color(hexString: "#E9E9E9"))
            
            //自定义分割线高度.发现粗细显示不一。所以最低还是支持1和Divider一样
//            RoundedRectangle(cornerRadius: 0)
//                .frame(maxWidth: .infinity)
//                .frame(height: 1)
//                .foregroundColor(Color(hexString: "#E9E9E9"))
        }.padding(.horizontal, 2)
            .background(Color(hexString: "#FFFFFF"))
            .onTapGesture {
                clickCallBack()
            }
            
    }
}
