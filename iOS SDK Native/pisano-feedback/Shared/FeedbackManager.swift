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
    
    func showFlow(flowId: String? = nil, customer: PisanoFeedback.PisanoCustomer? = nil, payload: [String : String]? = nil, feedbackCallback: @escaping ((PisanoFeedback.FeedbackCallback) -> Void)) {
        let pisano = Pisano(appId: "", accessKey: "", apiUrl: "")
        pisano.show(viewMode: .default, flowId: flowId, customer: customer, payload: payload) { callback in
            feedbackCallback(callback)
        }
    }
}
