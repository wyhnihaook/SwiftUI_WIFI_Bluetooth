//
//  BluetoothInfoData.swift
//  you
//  实践父视图同步数据到子视图【上级页面同步数据到下级页面】
//  Created by 翁益亨 on 2024/6/27.
//

import Foundation
class BluetoothInfoData : ObservableObject{
    @Published var name : String = "No Name"
    
    init(name: String) {
        self.name = name
    }
}
