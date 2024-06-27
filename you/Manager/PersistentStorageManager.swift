//
//  PersistentStorageManager.swift
//  you
//  持久化存储数据
//  Created by 翁益亨 on 2024/6/26.
//

import Foundation
class PersistentStorageManager {
    static let shared = PersistentStorageManager()
    
    private let defaults = UserDefaults.standard
    
    private let accountKey = "AccountKey"
    private let passwordKey = "PasswordKey"
    
    var account: String? {
        get {
            return defaults.string(forKey: accountKey)
        }
        set {
            if let account = newValue {
                defaults.set(account, forKey: accountKey)
            } else {
                defaults.removeObject(forKey: accountKey)
            }
        }
    }
    
    var password: String? {
        get {
            return defaults.string(forKey: passwordKey)
        }
        set {
            if let password = newValue {
                defaults.set(password, forKey: passwordKey)
            } else {
                defaults.removeObject(forKey: passwordKey)
            }
        }
    }
        
    func clearAccountInfo() {
        account = nil
        password = nil
    }
    
    //MARK: - 存储key为ssid，value为password的可连接的wifi信息
    func setSSIDWithPassword(ssid: String, password: String){
        defaults.set(password, forKey: ssid)
    }
    
    //MARK: - 根据ssid检索本地存储的password
    func getPasswordFromSSID(ssid: String) -> String?{
        return defaults.string(forKey: ssid)
    }
}
