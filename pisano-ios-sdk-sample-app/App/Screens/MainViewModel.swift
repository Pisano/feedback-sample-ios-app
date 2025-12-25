//
//  MainViewModel.swift
//  feedback
//
//  Created by Abdulkerim Şahin on 11.05.2022.
//

import SwiftUI

class MainViewModel: ObservableObject {
    
    @Published var state: AppState = .splash
    @Published var selectedFlow = ""
    @Published var isLoaded = false
}
