//
//  Dictionary.swift
//  pisano-feedback
//
//  Created by Abdulkerim Şahin on 12.10.2022.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    
    mutating func addIfNotEmpty(key: String, value: String?) {
        if let value = value, !value.isEmpty {
            self.updateValue(value, forKey: key)
        }
    }
}
