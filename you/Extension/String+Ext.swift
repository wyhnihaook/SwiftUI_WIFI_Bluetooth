//
//  String+Ext.swift
//  you
//
//  Created by 翁益亨 on 2024/8/1.
//

import Foundation
import SwiftUI

extension String {
    func camelCaseToKebabCase() -> String {
        unicodeScalars
            .dropFirst()
            .reduce(String(prefix(1))) { CharacterSet.uppercaseLetters.contains($1) ? $0 + "-" + String($1) : $0 + String($1) }
            .lowercased()
    }
}
