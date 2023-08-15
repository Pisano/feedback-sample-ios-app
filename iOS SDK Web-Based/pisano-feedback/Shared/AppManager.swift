//
//  AppState.swift
//  pisano-feedback
//
//  Created by Abdulkerim Şahin on 20.06.2022.
//

import SwiftUI
import Feedback

class AppManager {
    private init() {}
    
    static let shared = AppManager()
    var config: Config?
    
    func setPisanoFeedback(_ config: Config) {
        self.config = config
        
        Pisano.boot(appId: config.appId, accessKey: config.accessKey, apiUrl: config.apiUrl, feedbackUrl: config.feedbackUrl)
        
        #if(DEBUG)
        Pisano.debugMode(true)
        #endif
    }
}

indirect enum AppState: Equatable {
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.id == rhs.id
    }
    
    case splash
    case welcome
    case form
    
    var id: UUID { return UUID() }
}
