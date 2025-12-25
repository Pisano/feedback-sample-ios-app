//
//  FormViewModel.swift
//  pisano-feedback
//
//  Created by Abdulkerim Şahin on 27.06.2022.
//

import SwiftUI
import UIKit
import PisanoFeedback

class FormViewModel: ObservableObject {
    @Published var fullname = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var externalId = ""
    @Published var emailValidation = true
    @Published var sdkCallback: CloseStatus = .none
    @Published var customTitle: String = ""
    @Published var selectedColor: Color?
    @Published var selectedMode: ViewMode = .default
    @Published var selectedFont: UIFont = .preferredFont(forTextStyle: .title1)
    @Published var showSelectFont = false
    
    var colors: [Color] = [.blue, .green, .yellow, .darkGray, .lightGray, .black, .gray, .orange, .pink, .purple, .red]
    var fonts: [UIFont] = [.preferredFont(forTextStyle: .largeTitle), .preferredFont(forTextStyle: .title1), .preferredFont(forTextStyle: .title2), .preferredFont(forTextStyle: .title3), .preferredFont(forTextStyle: .headline), .preferredFont(forTextStyle: .subheadline), .preferredFont(forTextStyle: .body), .preferredFont(forTextStyle: .callout), .preferredFont(forTextStyle: .footnote), .preferredFont(forTextStyle: .caption1), .preferredFont(forTextStyle: .caption2)]
    var modes: [ViewMode] = [.default, .bottomSheet]
    
    func feedback() {
        emailValidation = email.isEmpty ? true : emailValidation
        
        var customer: [String: Any] = [:]
        customer.addIfNotEmpty(key: "email", value: email)
        customer.addIfNotEmpty(key: "name", value: fullname)
        customer.addIfNotEmpty(key: "phone", value: phone)
        customer.addIfNotEmpty(key: "externalId", value: externalId)
        
        var title: NSAttributedString?
        if !customTitle.isEmpty {
            if #available(iOS 14.0, *) {
                title = NSAttributedString(
                    string: customTitle,
                    attributes: [
                        .foregroundColor: UIColor(selectedColor ?? .black),
                        .font: selectedFont,
                    ]
                )
            } else {
                // iOS 13: SwiftUI Color -> UIColor conversion isn't available.
                title = NSAttributedString(string: customTitle, attributes: [.font: selectedFont])
            }
        }

        if emailValidation {
            FeedbackManager.shared.showFlow(mode: selectedMode, title: title, flowId: "", customer: customer.isEmpty ? nil : customer) { sdkcallback in
                self.sdkCallback = sdkcallback
            }
        }
    }
    
    func clear() {
        sdkCallback = .none
        FeedbackManager.shared.clear()
    }
}

extension ViewMode {
    var title: LocalizedStringKey {
        switch self {
        case .default: return .`default`
        case .bottomSheet: return .bottomSheet
        default: return ""
        }
    }
}
