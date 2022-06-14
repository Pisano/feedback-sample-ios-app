//
//  feedbackApp.swift
//  feedback
//
//  Created by YasinCetin on 28.04.2022.
//

import SwiftUI
import Feedback

@main
struct feedbackApp {
    static func main() {
        if #available(iOS 14.0, *) {
            MainAppView.main()
        } else {
            UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
        }
    }
}

@available(iOS 14.0, *)
struct MainAppView: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct MainView: View {
    
    init() {
        #if DEBUG
        Pisano.debugMode(true)
        #endif
        Pisano.boot(appId: "",
                    accessKey: "",
                    apiUrl: "",
                    feedbackUrl: "",
                    eventUrl: "")
    }
    
    var body: some View {
        Home()
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
        let contentView = MainView()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        //
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        //
    }

    func sceneWillResignActive(_ scene: UIScene) {
       //
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
       //
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        //
    }
}
