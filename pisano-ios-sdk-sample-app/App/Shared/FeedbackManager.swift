import SwiftUI
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
    
    func showFlow(mode: ViewMode = .default, title: NSAttributedString? = nil, flowId: String, customer: [String: Any]? = nil, completion: ((CloseStatus) -> Void)? = nil) {
        os_log("Pisano.show requested. mode=%{public}@ hasTitle=%{public}@ hasCustomer=%{public}@ hasFlowId=%{public}@",
               log: log,
               type: .info,
               String(describing: mode),
               title == nil ? "false" : "true",
               customer == nil ? "false" : "true",
               flowId.isEmpty ? "false" : "true")

        Pisano.healthCheck { [weak self] ok in
            os_log("Pisano.healthCheck result=%{public}@",
                   log: self?.log ?? OSLog.default,
                   type: ok ? .info : .error,
                   ok ? "true" : "false")

            Pisano.show(mode: mode,
                        title: title,
                        flowId: flowId,
                        language: "",
                        customer: customer) { status in
                os_log("Pisano.show callback. status=%{public}@",
                       log: self?.log ?? OSLog.default,
                       type: .info,
                       status.description)
                completion?(status)
            }
        }
    }
    
    func clear() {
        os_log("Pisano.clear called.", log: log, type: .info)
        Pisano.clear()
    }
}
