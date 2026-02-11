import Foundation
import PisanoFeedback
import os.log

class FeedbackManager {
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
                  customer: [String: Any]? = nil,
                  payload: [String: String]? = nil,
                  code: String? = nil,
                  completion: ((CloseStatus) -> Void)? = nil) {
        os_log("Pisano.show requested. mode=%{public}@ hasTitle=%{public}@ hasCustomer=%{public}@ hasPayload=%{public}@ hasCodeOverride=%{public}@",
               log: log,
               type: .info,
               String(describing: mode),
               title == nil ? "false" : "true",
               customer == nil ? "false" : "true",
               payload == nil ? "false" : "true",
               code == nil ? "false" : "true")

        Pisano.show(mode: mode,
                    title: title,
                    language: language,
                    customer: customer,
                    payload: payload,
                    code: code) { [weak self] status in
            os_log("Pisano.show callback. status=%{public}@",
                   log: self?.log ?? OSLog.default,
                   type: .info,
                   status.description)
            completion?(status)
        }
    }
    
    func clear() {
        os_log("Pisano.clear called.", log: log, type: .info)
        Pisano.clear()
    }
}
