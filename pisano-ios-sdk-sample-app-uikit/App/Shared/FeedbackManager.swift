import Foundation
import PisanoFeedback
import os.log

@MainActor
final class FeedbackManager {
    /// How the screen passes the customer: the dictionary or the typed
    /// `PisanoCustomer` variant of `Pisano.show`.
    enum Customer {
        case dictionary([String: Any]?)
        case typed(PisanoCustomer)
    }

    private init() { }

    static let shared = FeedbackManager()
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "PisanoSample", category: "Feedback")
    
    var flowCreated: Bool {
        set {
            UserDefaults.standard.set(true, forKey: "flowCreated")
        }
        get {
            return UserDefaults.standard.bool(forKey: "flowCreated")
        }
    }
    
    func showFlow(mode: ViewMode = .default,
                  title: NSAttributedString? = nil,
                  language: String? = nil,
                  customer: Customer = .dictionary(nil),
                  payload: [String: String]? = nil,
                  code: String? = nil,
                  dismissOnDrag: Bool = false,
                  completion: (@MainActor @Sendable (CloseStatus) -> Void)? = nil) {
        let isTyped: Bool
        if case .typed = customer { isTyped = true } else { isTyped = false }
        os_log("""
               Pisano.show requested. mode=%{public}@ dismissOnDrag=%{public}@ hasTitle=%{public}@ \
               typedCustomer=%{public}@ hasPayload=%{public}@ hasCodeOverride=%{public}@
               """,
               log: log,
               type: .info,
               String(describing: mode),
               dismissOnDrag ? "true" : "false",
               title == nil ? "false" : "true",
               isTyped ? "true" : "false",
               payload == nil ? "false" : "true",
               code == nil ? "false" : "true")

        let log = self.log
        let onResult: @MainActor @Sendable (CloseStatus) -> Void = { status in
            os_log("Pisano.show callback. status=%{public}@", log: log, type: .info, status.description)
            completion?(status)
        }
        switch customer {
        case .dictionary(let dictionary):
            Pisano.show(mode: mode, title: title, language: language, customer: dictionary,
                        payload: payload, code: code, dismissOnDrag: dismissOnDrag, completion: onResult)
        case .typed(let typed):
            Pisano.show(mode: mode, title: title, language: language, pisanoCustomer: typed,
                        payload: payload, code: code, dismissOnDrag: dismissOnDrag, completion: onResult)
        }
    }
    
    func clear() {
        os_log("Pisano.clear called.", log: log, type: .info)
        Pisano.clear()
    }
}
