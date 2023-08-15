//
//  AppState.swift
//  pisano-feedback
//
//  Created by Abdulkerim Şahin on 20.06.2022.
//

import SwiftUI

class AppManager {
    private init() {}
    
    static let shared = AppManager()
    var config: Config?
    
    func setPisanoFeedback(_ config: Config) {
        self.config = config
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
