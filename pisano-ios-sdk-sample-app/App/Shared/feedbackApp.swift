import SwiftUI
import PisanoFeedback
import os.log

@main
struct feedbackApp {
    static func main() {
            UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
    }
}

struct AppView: View {
    var body: some View {
        MainView()
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "PisanoSample", category: "App")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITableView.appearance().backgroundColor = .clear
#if DEBUG
        if PisanoSDKConfig.debugLogging {
            Pisano.debugMode(true)
        }
#endif

        os_log("App didFinishLaunching. usesSecretsPlist=%{public}@ missingRequiredKeys=%{public}@",
               log: log,
               type: .info,
               PisanoSDKConfig.usesSecretsPlist ? "true" : "false",
               PisanoSDKConfig.missingRequiredKeys.joined(separator: ","))

        if PisanoSDKConfig.isValid {
            let cfg = PisanoSDKConfig.config
            Pisano.boot(appId: cfg.appId,
                        accessKey: cfg.accessKey,
                        code: cfg.code,
                        apiUrl: cfg.apiUrl,
                        feedbackUrl: cfg.feedbackUrl,
                        eventUrl: cfg.eventUrl.isEmpty ? nil : cfg.eventUrl) { status in
                os_log("Pisano.boot completed. status=%{public}@",
                       log: self.log,
                       type: .info,
                       status.description)
            }
        } else {
            os_log("Pisano SDK config is missing. Provide credentials via Info.plist keys or PisanoSecrets.plist (do not commit).",
                   log: log,
                   type: .error)
        }
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
          sceneConfig.delegateClass = SceneDelegate.self
          return sceneConfig
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = AppView()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
