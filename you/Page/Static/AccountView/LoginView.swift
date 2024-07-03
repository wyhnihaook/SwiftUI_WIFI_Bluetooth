//
//  LoginView.swift
//  you
//
//  Created by 翁益亨 on 2024/7/3.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
//        ZStack(alignment:.bottom){
//            //背景介绍内容
//            Rectangle().frame(maxWidth: .infinity,maxHeight: .infinity).background(.blue)
//
////            VStack{
////
////            }.frame(maxWidth:.infinity,maxHeight: 500).background(.white).cornerRadius(20)
//
//
//
//
//        }.background(.red)
//        NavigationLink(destination: OtherView()) {
//            Text("登录")
//        }
    

        VStack{
            Text("111")
            Spacer()
        }.navigationBarHidden(true)
            .toolbar{
                Text("1")
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
