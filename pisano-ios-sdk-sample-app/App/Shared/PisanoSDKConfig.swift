//
//  PisanoSDKConfig.swift
//  pisano-feedback
//
//  Sample app helper: reads Pisano credentials from Info.plist.
//

import Foundation

enum PisanoSDKConfig {
    static var appId: String { value("PISANO_APP_ID") }
    static var accessKey: String { value("PISANO_ACCESS_KEY") }
    static var apiUrl: String { value("PISANO_API_URL") }
    static var feedbackUrl: String { value("PISANO_FEEDBACK_URL") }
    static var eventUrl: String { value("PISANO_EVENT_URL") }

    static var isValid: Bool {
        !appId.isEmpty && !accessKey.isEmpty && !apiUrl.isEmpty && !feedbackUrl.isEmpty
    }

    private static let secrets: [String: Any] = {
        guard let url = Bundle.main.url(forResource: "PisanoSecrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let obj = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
              let dict = obj as? [String: Any] else {
            return [:]
        }
        return dict
    }()

    /// Reads from `PisanoSecrets.plist` (if present in app bundle) first, otherwise falls back to app `Info.plist`.
    private static func value(_ key: String) -> String {
        if let raw = secrets[key] as? String {
            let v = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            if !v.isEmpty { return v }
        }

        return (Bundle.main.object(forInfoDictionaryKey: key) as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}


