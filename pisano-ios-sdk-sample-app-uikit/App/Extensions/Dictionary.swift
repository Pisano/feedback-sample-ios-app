import Foundation

extension Dictionary where Key == String, Value == Any {
    mutating func addIfNotEmpty(key: String, value: String?) {
        if let value, !value.isEmpty {
            self[key] = value
        }
    }
}
