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
    
    /// Boots the SDK with the configured credentials. `clear()` makes the SDK
    /// forget them, so the samples call this again after `clear()`.
    func boot(completion: (@MainActor (Bool) -> Void)? = nil) {
        guard PisanoSDKConfig.isValid else {
            os_log("Pisano SDK config is missing. Provide credentials via Info.plist keys or PisanoSecrets.plist (do not commit).",
                   log: log,
                   type: .error)
            completion?(false)
            return
        }
        let cfg = PisanoSDKConfig.config
        let log = self.log
        Pisano.boot(appId: cfg.appId,
                    accessKey: cfg.accessKey,
                    code: cfg.code,
                    apiUrl: cfg.apiUrl,
                    feedbackUrl: cfg.feedbackUrl,
                    eventUrl: cfg.eventUrl.isEmpty ? nil : cfg.eventUrl) { succeeded in
            os_log("Pisano.boot completed. succeeded=%{public}@",
                   log: log,
                   type: .info,
                   succeeded ? "true" : "false")
            completion?(succeeded)
        }
    }

    func clear() {
        os_log("Pisano.clear called.", log: log, type: .info)
        Pisano.clear()
    }
}
