import Foundation

extension Dictionary where Key == String, Value == Any {
    mutating func addIfNotEmpty(key: String, value: String?) {
        if let value, !value.isEmpty {
            self[key] = value
        }
    }
}

extension Optional where Wrapped == String {
    /// The trimmed text, or nil when it is empty.
    var nonEmpty: String? {
        guard let text = self?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return nil }
        return text
    }
}
