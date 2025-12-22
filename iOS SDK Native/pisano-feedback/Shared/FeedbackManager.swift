//
//  FeedbackManager.swift
//  pisano-feedback
//
//  Created by Abdulkerim Şahin on 21.06.2022.
//

import SwiftUI
import PisanoFeedback

class FeedbackManager {
    private init() { }
    
    static let shared = FeedbackManager()
    
    func showFlow(mode: ViewMode = .default,
                  title: NSAttributedString? = nil,
                  flowId: String? = nil,
                  language: String? = nil,
                  customer: [String: Any]? = nil,
                  payload: [String: String]? = nil,
                  completion: @escaping (CloseStatus) -> Void) {
        guard PisanoSDKConfig.isValid else {
            print("Pisano SDK config is missing. Please set PISANO_APP_ID / PISANO_ACCESS_KEY / PISANO_API_URL / PISANO_FEEDBACK_URL in Info.plist.")
            completion(.initFailed)
            return
        }

        Pisano.show(mode: mode,
                    title: title,
                    flowId: flowId,
                    language: language,
                    customer: customer,
                    payload: payload,
                    completion: completion)
    }
}
