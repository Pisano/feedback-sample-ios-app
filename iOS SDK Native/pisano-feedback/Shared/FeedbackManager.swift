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
    
    var flowCreated: Bool {
        set {
            UserDefaults.standard.set(true, forKey: "flowCreated")
        }
        get {
            return UserDefaults.standard.bool(forKey: "flowCreated")
        }
    }
    
    func showFlow(flowId: String? = nil, customer: PisanoFeedback.PisanoCustomer? = nil, payload: [String : String]? = nil, feedbackCallback: @escaping ((PisanoFeedback.FeedbackCallback) -> Void)) {
        if let config = AppManager.shared.config {
            let pisano = Pisano(appId: config.appId, accessKey: config.accessKey, apiUrl: config.apiUrl)
            pisano.show(flowId: flowId, customer: customer, payload: payload) { callback in
                feedbackCallback(callback)
            }
        }
    }
    
    func clear() {
    }
}
