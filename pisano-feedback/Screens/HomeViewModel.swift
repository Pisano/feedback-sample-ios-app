//
//  HomeViewModel.swift
//  feedback
//
//  Created by Abdulkerim Şahin on 11.05.2022.
//

import SwiftUI
import Feedback

class HomeViewModel: ObservableObject {
    @Published var state: State = .splash
    @Published var fullname: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var sdkCallback: SDKCallback = .none
    
    @Published var emailValidation: Bool = true
    
    enum State {
        case splash
        case home
    }
    
    enum SDKCallback: String {
        case none = ""
        case close = "closed"
        case sendFeedback = "sendFeedback"
        case other = "outside"
        case open = "opened"
        case displayOnce = "displayOnce"
        case preventMultipleFeedback = "preventMultipleFeedback"
        
        var description: String {
            switch self {
            case .none:
                return ""
            case .close:
                return "Closed"
            case .sendFeedback:
                return "Send Feedback"
            case .open:
                return "Opened"
            case .displayOnce:
                return "Survey won't be shown due to the customer saw it before."
            case .preventMultipleFeedback:
                return "Survey won't be shown due to customer already submitted a feedback in a given time period."
            case .other:
                return "Other"
            }
        }
    }
    
    func feedback() {
        guard emailValidation == true else { return }
        Pisano.show(flowId: "",
                    language: "",
                    customer: ["email": email,
                               "name": fullname,
                               "phone": phone])
        
        NotificationCenter.default.addObserver(forName: .sdkCallbackNotification,
                                               object: nil,
                                               queue: .main) { notification in
            if let userInfo = notification.userInfo,
               let closeStatus = userInfo["closeStatus"] as? String,
               let sdkCallback = SDKCallback(rawValue: closeStatus) {
                self.sdkCallback = sdkCallback
            }
        }
    }
}
