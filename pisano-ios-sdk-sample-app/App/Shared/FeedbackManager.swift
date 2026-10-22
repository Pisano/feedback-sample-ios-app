import Foundation
import PisanoFeedback
import os.log

@MainActor
final class FeedbackManager {
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
                  customer: PisanoCustomer? = nil,
                  payload: [String: String]? = nil,
                  code: String? = nil,
                  dismissOnDrag: Bool = false,
                  completion: (@MainActor @Sendable (CloseStatus) -> Void)? = nil) {
        os_log("""
               Pisano.show requested. mode=%{public}@ dismissOnDrag=%{public}@ hasTitle=%{public}@ \
               hasCustomer=%{public}@ hasPayload=%{public}@ hasCodeOverride=%{public}@
               """,
               log: log,
               type: .info,
               String(describing: mode),
               dismissOnDrag ? "true" : "false",
               title == nil ? "false" : "true",
               customer == nil ? "false" : "true",
               payload == nil ? "false" : "true",
               code == nil ? "false" : "true")

        let log = self.log
        let onResult: @MainActor @Sendable (CloseStatus) -> Void = { status in
            os_log("Pisano.show callback. status=%{public}@", log: log, type: .info, status.description)
            completion?(status)
        }
        Pisano.show(mode: mode, title: title, language: language, pisanoCustomer: customer,
                    payload: payload, code: code, dismissOnDrag: dismissOnDrag, completion: onResult)
    }
    
    func clear() {
        os_log("Pisano.clear called.", log: log, type: .info)
        Pisano.clear()
    }
}
