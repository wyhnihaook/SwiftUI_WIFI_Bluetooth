//
//  TransferView.swift
//  you
//  转写页面
//  Created by 翁益亨 on 2024/7/8.
//

import SwiftUI

struct TransferView: View {
//    @State private var audioTransfers: [AudioTransfer] = []
    
    var transferList : [FileTransferData]
    
    init(transferList : [FileTransferData]?) {
        self.transferList = transferList ?? []
    }
    
    var body: some View {
        ScrollView{
            LazyVStack(spacing:20){
                ForEach(transferList,id:\.transferId) { transfer in
                    TransferDataView(fileTransferData: transfer)
                    
//                    TransferDataView(audioTransfer: audioTransfer)
                }
            }
        }
        //TabView的页面都需要单独设置背景颜色，不然底部会出现默认的TabView底部样式
        .background(.white)
        .padding(0)
        .frame(maxWidth: .infinity)
//        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .onAppear(perform: load)
    }
    
    func load() {
//        guard audioTransfers.isEmpty else { return }
//        audioTransfers = AudioTransfer.all
    }
}

struct TransferView_Previews: PreviewProvider {
    static var previews: some View {
        TransferView(transferList: [])
    }
}
