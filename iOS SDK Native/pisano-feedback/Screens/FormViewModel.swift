//
//  FormViewModel.swift
//  pisano-feedback
//
//  Created by Abdulkerim Şahin on 27.06.2022.
//

import SwiftUI
import PisanoFeedback

class FormViewModel: ObservableObject {
    @Published var fullname = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var externalId = ""
    @Published var emailValidation = true
    @Published var feedbackCallback: FeedbackCallback = .unknown
    
    func feedback() {
        emailValidation = email.isEmpty ? true : emailValidation
        
        if emailValidation {
            let pisanoCustomer = PisanoCustomer(name: fullname, email: email, phoneNumber: phone, externalId: externalId)
            FeedbackManager.shared.showFlow(customer: pisanoCustomer) { callback in
                self.feedbackCallback = callback
            }
        }
    }
    
    func clear() {
        feedbackCallback = .unknown
    }
}
