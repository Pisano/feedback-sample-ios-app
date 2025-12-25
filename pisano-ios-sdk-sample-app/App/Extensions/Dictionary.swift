import Foundation

extension Dictionary where Key == String, Value == Any {
    
    mutating func addIfNotEmpty(key: String, value: String?) {
        if let value = value, !value.isEmpty {
            self.updateValue(value, forKey: key)
        }
    }
}
