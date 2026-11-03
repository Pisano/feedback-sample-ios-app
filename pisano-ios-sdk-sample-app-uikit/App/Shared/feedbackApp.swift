import UIKit
import PisanoFeedback
import os.log

@main
struct feedbackApp {
    static func main() {
        UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
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

        FeedbackManager.shared.boot()
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
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let root = UINavigationController(rootViewController: WelcomeViewController())
            root.navigationBar.prefersLargeTitles = true
            window.rootViewController = root
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
