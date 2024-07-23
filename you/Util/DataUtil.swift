//
//  DataUtil.swift
//  you
//
//  Created by 翁益亨 on 2024/7/12.
//

import Foundation

//MARK: - 字符串转结构体
func decodeJson<T: Decodable>(from jsonString: String) -> T? {
    guard let jsonData = jsonString.data(using: .utf8) else {
        return nil
    }
    
    do {
        let decoder = JSONDecoder()
        let decodedObject = try decoder.decode(T.self, from: jsonData)
        return decodedObject
    } catch {
        print("Error decoding JSON string: \(error)")
        return nil
    }
}


//MARK: - 结构体转字符串
///参数示例：let person = Person(name: "Jane Doe", age: 25)
func encodeToJson<T: Encodable>(_ object: T) -> String? {
    do {
        let jsonData = try JSONEncoder().encode(object)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
    } catch {
        print("Error encoding object to JSON: \(error)")
    }
    return nil
}

//MARK: - 验证邮箱可用性
func validateEmail(_ email: String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
   }
