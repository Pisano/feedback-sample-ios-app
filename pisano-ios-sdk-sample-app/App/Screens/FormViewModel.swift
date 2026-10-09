import SwiftUI
import UIKit
import StoreKit
import PisanoFeedback

@MainActor
class FormViewModel: ObservableObject {
    @Published var fullname = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var externalId = ""
    @Published var plan = ""
    /// Send the customer as the typed `PisanoCustomer` instead of a dictionary.
    @Published var typedCustomer = true
    /// `Pisano.automaticStoreReview`: off, the app asks for the review prompt
    /// itself on the `redirectedToStore` event.
    @Published var automaticStoreReview = Pisano.automaticStoreReview {
        didSet { Pisano.automaticStoreReview = automaticStoreReview }
    }
    /// What `Pisano.subscribe` reported for the last survey, in order.
    @Published var events: [String] = []
    @Published var emailValidation = true
    @Published var sdkCallback: CloseStatus = .none
    @Published var customTitle: String = ""
    @Published var selectedColor: Color?
    @Published var selectedMode: ViewMode = .default
    @Published var dismissOnDrag = false
    @Published var selectedFont: UIFont = .preferredFont(forTextStyle: .title1)
    @Published var showSelectFont = false
    @Published var preflightStatus: String = ""
    
    var colors: [Color] = [.blue, .green, .yellow, .darkGray, .lightGray, .black, .gray, .orange, .pink, .purple, .red]
    var fonts: [UIFont] = [.preferredFont(forTextStyle: .largeTitle), .preferredFont(forTextStyle: .title1), .preferredFont(forTextStyle: .title2), .preferredFont(forTextStyle: .title3), .preferredFont(forTextStyle: .headline), .preferredFont(forTextStyle: .subheadline), .preferredFont(forTextStyle: .body), .preferredFont(forTextStyle: .callout), .preferredFont(forTextStyle: .footnote), .preferredFont(forTextStyle: .caption1), .preferredFont(forTextStyle: .caption2)]
    var modes: [ViewMode] = [.default, .bottomSheet]

    private var subscription: PisanoSubscription?

    init() {
        subscription = Pisano.subscribe { [weak self] event in
            self?.record(event)
        }
    }

    deinit {
        subscription?.cancel()
    }

    /// The customer as a dictionary: keys are checked at run time, and an
    /// unknown one is logged and dropped.
    private var customerDictionary: [String: Any]? {
        var customer: [String: Any] = [:]
        customer.addIfNotEmpty(key: "email", value: email)
        customer.addIfNotEmpty(key: "name", value: fullname)
        customer.addIfNotEmpty(key: "phoneNumber", value: phone)
        customer.addIfNotEmpty(key: "externalId", value: externalId)
        if !plan.isEmpty {
            customer["customAttributes"] = ["plan": plan]
        }
        return customer.isEmpty ? nil : customer
    }

    /// The same customer with typed fields: a misspelled field does not compile.
    private var pisanoCustomer: PisanoCustomer {
        PisanoCustomer(name: fullname.isEmpty ? nil : fullname,
                       email: email.isEmpty ? nil : email,
                       phoneNumber: phone.isEmpty ? nil : phone,
                       externalId: externalId.isEmpty ? nil : externalId,
                       customAttributes: plan.isEmpty ? nil : ["plan": plan])
    }

    func feedback() {
        emailValidation = email.isEmpty ? true : emailValidation

        var title: NSAttributedString?
        if !customTitle.isEmpty {
            title = NSAttributedString(
                string: customTitle,
                attributes: [
                    .foregroundColor: UIColor(selectedColor ?? .black),
                    .font: selectedFont,
                ]
            )
        }

        guard emailValidation else { return }

        preflightStatus = "HealthCheck: running..."
        let language = PisanoSDKConfig.language.isEmpty ? nil : PisanoSDKConfig.language
        let customer: FeedbackManager.Customer = typedCustomer ? .typed(pisanoCustomer) : .dictionary(customerDictionary)
        // SDK completions are delivered on the main thread.
        Pisano.healthCheck(language: language) { isHealthy in
            guard isHealthy else {
                self.preflightStatus = "HealthCheck: failed (check network/urls)"
                return
            }

            self.preflightStatus = "HealthCheck: ok"
            self.events = []
            FeedbackManager.shared.showFlow(mode: self.selectedMode,
                                            title: title,
                                            language: language,
                                            customer: customer,
                                            dismissOnDrag: self.dismissOnDrag) { status in
                self.sdkCallback = status
            }
        }
    }

    private func record(_ event: PisanoEvent) {
        switch event.type {
        case .opened:
            events.append("opened")
        case .feedbackSubmitted:
            events.append(event.hasChat ? "feedbackSubmitted (chat)" : "feedbackSubmitted")
        case .redirectedToStore:
            events.append(event.handledBySDK ? "redirectedToStore (SDK asked)" : "redirectedToStore (app asks)")
            if !event.handledBySDK, let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) {
                SKStoreReviewController.requestReview(in: scene)
            }
        case .closed:
            events.append("closed (\(Self.name(of: event.closeReason)))")
        @unknown default:
            events.append("unknown event")
        }
    }

    private static func name(of reason: PisanoCloseReason) -> String {
        switch reason {
        case .none: return "none"
        case .closeButton: return "closeButton"
        case .drag: return "drag"
        case .outside: return "outside"
        case .afterSubmit: return "afterSubmit"
        case .clear: return "clear"
        case .loadFailed: return "loadFailed"
        case .hostDismissed: return "hostDismissed"
        @unknown default: return "unknown"
        }
    }
    
    func clear() {
        sdkCallback = .none
        preflightStatus = ""
        dismissOnDrag = false
        events = []
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
