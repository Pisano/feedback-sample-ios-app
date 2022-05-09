//
//  NavigationManager.swift
//  feedback
//
//  Created by YasinCetin on 29.04.2022.
//

import Foundation
import SwiftUI

class NavigationManager:ObservableObject {
    @Published var selection:String?
    
    init() {
        selection = "splashView"
    }
}
