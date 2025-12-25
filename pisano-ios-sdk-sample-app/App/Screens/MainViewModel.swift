import SwiftUI

class MainViewModel: ObservableObject {
    
    @Published var state: AppState = .splash
    @Published var selectedFlow = ""
    @Published var isLoaded = false
}
