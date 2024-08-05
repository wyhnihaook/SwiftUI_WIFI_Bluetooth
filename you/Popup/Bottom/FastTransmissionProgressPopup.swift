//
//  FastTransmissionProgressPopup.swift
//  you
//  连接快速传输之后的弹窗
//  Created by 翁益亨 on 2024/8/5.
//

import SwiftUI

struct FastTransmissionProgressPopup : BottomPopup{
    @State private var showProgressIndicator: Bool = true
    @State private var progress: CGFloat = 0.0
    @State private var enableAutoProgress: Bool = true
    @State private var progressForDefaultSector: CGFloat = 0.0
    private let timer = Timer.publish(every: 1 / 5, on: .main, in: .common).autoconnect()
        
    func createContent() -> some View {
        VStack(spacing:0){
            Text("快速传输").bold().modifier(PopupTitleStyle()).padding(.top, 20).padding(.bottom, 40)
            
            
            //传输的进度
            createProgress()
            
            //点击结束传输
            Button{
                print("结束传输")
            }label: {
                Text("结束快速传输").bold().foregroundColor(.red).font(.system(size: 14))
            }.padding(.top, 30)
        }.padding([.bottom,.horizontal], 15)
    }
    
}

extension FastTransmissionProgressPopup {
    func createProgress() -> some View{
        GeometryReader { geometry in
//                    let size = geometry.size.width / 5
                    
                    VStack {
                        
                        ProgressIndicatorView(isVisible: $showProgressIndicator, type: .bar(progress: $progress, backgroundColor: .gray.opacity(0.25)))
                            .frame(height: 8.0)
                            .foregroundColor(.red)
                            .padding(.bottom,10)
//                            .padding([.bottom, .horizontal], 15)
                        
                        HStack(spacing:0){
                            Text("0/1文件").font(.system(size: 14)).foregroundColor(.blue).frame(maxWidth: .infinity,alignment: .leading)
                            
                            Text("0 B/s").font(.system(size: 14)).foregroundColor(.black)
                        }
                            
                        //以下内容为显示的所有样式
//                        ProgressIndicatorView(isVisible: $showProgressIndicator, type: .impulseBar(progress: $progress, backgroundColor: .gray.opacity(0.25)))
//                            .frame(height: 8.0)
//                            .foregroundColor(.red)
//                            .padding([.bottom, .horizontal], size)
//
//                        ProgressIndicatorView(isVisible: $showProgressIndicator, type: .dashBar(progress: $progress, numberOfItems: 8, backgroundColor: .gray.opacity(0.25)))
//                            .frame(height: 12.0)
//                            .foregroundColor(.red)
//                            .padding([.bottom, .horizontal], size)
//
//                        HStack {
//                            Spacer()
//                            ProgressIndicatorView(isVisible: $showProgressIndicator, type: .default(progress: $progressForDefaultSector))
//                                .foregroundColor(.red)
//                                .frame(width: size, height: size)
//                            Spacer()
//                            ProgressIndicatorView(isVisible: $showProgressIndicator, type: .circle(progress: $progress, lineWidth: 8.0, strokeColor: .red, backgroundColor: .gray.opacity(0.25)))
//                                .frame(width: size, height: size)
//                            Spacer()
//                        }
//
//                        Spacer()
                    }
        }
        //这里要设置好对应的显示高度
        .frame(height:100)
                .onReceive(timer) { _ in
                    guard enableAutoProgress else { return }
                    switch progress {
                    case ...0.3, 0.4...0.6:
                        progress += 1 / 30
                    case 0.3...0.4, 0.6...0.9:
                        progress += 1 / 120
                    case 0.9...0.99:
                        progress = 1
                    case 1.0...:
                        progress = 0
                    default:
                        break
                    }
                    
                    if progressForDefaultSector >= 1.5 {
                        progressForDefaultSector = 0
                    } else {
                        progressForDefaultSector += 1 / 10
                    }
                }
    }
}
