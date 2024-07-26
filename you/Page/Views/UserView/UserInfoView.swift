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
    
    //操作图片操作的弹窗
    @State private var isImagePickerPresented = false
    @State private var isImageCameraPickerPresented = false
    @State private var isImagePhotoPickerPresented = false
    @State private var selectedImage: UIImage?
    
    //控制toast显示
    @State private var showToast = false
    
    //退出登录弹窗控制
    @State private var isShowOutLoginDialog = false

    
    @StateObject var userModel = UserModel()
    
    var body: some View {
        //外部NavigationLink跳转到一个新的导航器，内容全部自定义
        NavigationBody(title: "账号和资料") {
            HStack{
//                Text("1")
//                Text("2")
            }
        } content: {
            VStack(spacing:0){
                Spacer().frame(height: 10)
                   
                //头像更换
                ZStack(alignment:.bottomTrailing){

                    AsyncImage(url: URL(string: userModel.headerImage)){
                        image in
                        image.resizable().aspectRatio(contentMode: .fit).frame(width: 80, height: 80)
                            .cornerRadius(40)
                    } placeholder: {
                        //默认占位
                        Image("icon_head_default")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    
                    Image("icon_camera")
                        .resizable()
                        .frame(width: 22, height: 22)
                }.frame(height: 100).onTapGesture(perform: {
                    isImagePickerPresented.toggle()
                }).actionSheet(isPresented: $isImagePickerPresented) {
                    //弹出弹窗选择相册或者拍照上传头像。title固定占位，如果不需要头部的占位信息就需要自定义实现页面结合sheet实现
                    ActionSheet(title: Text("请选择图片获取方式"),buttons: [
                        //选择项添加
                        .default(Text("拍照")){
                            isImageCameraPickerPresented.toggle()
                        },
                        
                        .default(Text("从照片中选择")){
                            isImagePhotoPickerPresented.toggle()
                        },
                        
                        //取消按钮添加
                        .cancel()
                    ])
                }
                
                Spacer().frame(height: 10)
                
                //基本信息
                Group{
                    NavigationLink(destination: EditUsernameView(username: userModel.user?.username?.value ?? ""){
                        showToast.toggle()
                    },isActive: $userModel.isToEdit) {}
                    
                    NavigationLink(destination: ModifyPasswordView(),isActive: $userModel.isToModifyPassword) {}
                    
                    AccountLabel(title: "昵称", desc: userModel.user?.username?.value ?? ""){
                        userModel.isToEdit.toggle()
                    }
                   
                    AccountLabel(title: "邮箱", desc: userModel.user?.email?.value ?? "",canOperate: false)
                    AccountLabel(title: "更改密码"){
                        userModel.isToModifyPassword.toggle()
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
                        //添加展示动画效果
                        withAnimation {
                            isShowOutLoginDialog.toggle()
                        }
                        //跳转完成之后会被重置成false未激活
//                        isLinkLoginActive = true
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
            
        }.onAppear{
            //每次页面显示都尝试获取最新的用户信息数据
            userModel.getUserInfo()
            
        }.overlay(content: {
            //覆盖在界面上的弹窗信息
            if isShowOutLoginDialog{
                OutLoginDialog(showDialog: $isShowOutLoginDialog){
                    //退出登录跳转到登录页面
                    isLinkLoginActive.toggle()
                }
            }
        }).toast(isPresenting: $showToast, duration: 1.0, tapToDismiss:false){
            AlertToast(type: .regular,title: "保存完成",style: .style(backgroundColor:Color(r: 0, g: 0, b: 0,a: 0.75),titleColor: .white))
            
            // `.alert` is the default displayMode【没有背景内容】
//            AlertToast(type: .regular,title: "保存成功",style: .style(backgroundColor:.gray))
            
            //Choose .hud to toast alert from the top of the screen【从顶部弹出到标题栏位置】
//            AlertToast(displayMode: .hud, type: .regular, title: "Message Sent!")
            
            //Choose .banner to slide/pop alert from the bottom of the screen【动画效果滑入滑出】
//            AlertToast(displayMode: .banner(.slide), type: .regular, title: "Message Sent!")
        }.fullScreenCover(isPresented: $isImageCameraPickerPresented, content: {
            ImageCameraPicker(selectedImage: $selectedImage)
        }).fullScreenCover(isPresented: $isImagePhotoPickerPresented, content: {
            ImagePhotoPicker(selectedImage: $selectedImage)
        }).onChange(of: selectedImage) { newValue in
            //监听图片变化，变化后上传完成后重新获取用户信息
            
            if let data = selectedImage?.pngData(){
                userModel.saveHeaderImage(data: data)
            }else{
                print("数据错误")
            }
        }

     
        
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
            
//            Divider().background(Color(hexString: "#E9E9E9"))
            
            //自定义分割线高度.发现粗细显示不一。所以最低还是支持1和Divider一样
            RoundedRectangle(cornerRadius: 0)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundColor(Color(hexString: "#f4f4f4"))
        }.padding(.horizontal, 2)
            .background(Color(hexString: "#FFFFFF"))
            .onTapGesture {
                clickCallBack()
            }
            
    }
}
