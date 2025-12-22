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
    @Published var closeStatus: CloseStatus = .none
    
    func feedback() {
        emailValidation = email.isEmpty ? true : emailValidation
        
        if emailValidation {
            var customer: [String: Any] = [:]
            customer.addIfNotEmpty(key: "email", value: email)
            customer.addIfNotEmpty(key: "name", value: fullname)
            customer.addIfNotEmpty(key: "phoneNumber", value: phone)
            customer.addIfNotEmpty(key: "externalId", value: externalId)

            FeedbackManager.shared.showFlow(customer: customer.isEmpty ? nil : customer) { status in
                self.closeStatus = status
            }
        }
    }
    
    func clear() {
        closeStatus = .none
        Pisano.clear()
    }
}
