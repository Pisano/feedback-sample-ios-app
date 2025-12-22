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
    
    func showFlow(mode: ViewMode = .default, title: NSAttributedString? = nil, flowId: String, customer: [String: Any]? = nil, completion: ((CloseStatus) -> Void)? = nil) {
        Pisano.show(mode: mode,
                    title: title,
                    flowId: flowId,
                    language: "",
                    customer: customer) { status in
            completion?(status)
        }
    }
    
    func clear() {
        Pisano.clear()
    }
}
