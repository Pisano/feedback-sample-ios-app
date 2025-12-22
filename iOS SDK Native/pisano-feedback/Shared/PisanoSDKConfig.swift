//
//  PisanoSDKConfig.swift
//  pisano-feedback
//
//  Sample app helper: reads Pisano credentials from Info.plist.
//

import Foundation

enum PisanoSDKConfig {
    static var appId: String { info("PISANO_APP_ID") }
    static var accessKey: String { info("PISANO_ACCESS_KEY") }
    static var apiUrl: String { info("PISANO_API_URL") }
    static var feedbackUrl: String { info("PISANO_FEEDBACK_URL") }
    static var eventUrl: String { info("PISANO_EVENT_URL") }

    static var isValid: Bool {
        !appId.isEmpty && !accessKey.isEmpty && !apiUrl.isEmpty && !feedbackUrl.isEmpty
    }

    private static func info(_ key: String) -> String {
        (Bundle.main.object(forInfoDictionaryKey: key) as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}


