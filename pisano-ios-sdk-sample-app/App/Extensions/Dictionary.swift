import Foundation

extension Optional where Wrapped == String {
    /// The trimmed text, or nil when it is empty.
    var nonEmpty: String? {
        guard let text = self?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return nil }
        return text
    }
}
