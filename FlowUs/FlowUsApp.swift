//
//  FlowUsApp.swift
//  FlowUs
//
//  Created by Lucas Goldner on 18.07.21.
//

import Firebase
import L10n_swift
import SwiftUI
import UIPilot

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        FirebaseApp.configure()
        Configuration.shared.setupConfig()
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
    {
        let handled = DynamicLinks.dynamicLinks()
            .handleUniversalLink(userActivity.webpageURL!) { _, _ in
            }

        return handled
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool
    {
        if DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) != nil {
            // Handle the deep link. For example, show the deep-linked content or
            // apply a promotional offer to the user's account.
            // ...
            return true
        }
        return false
    }
}

@main
struct FlowUsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var pilot = UIPilot(initial: AppRoute.Welcome)
    @Environment(\.colorScheme) var colorScheme
    init() {
        UIScrollView.appearance().keyboardDismissMode = .interactive
    }

    var body: some Scene {
        WindowGroup {
            UIPilotHost(pilot) { route in
                switch route {
                case .Welcome:
                    return AnyView(WelcomeView()
                        .navigationBarHidden(true))
                case .Login:
                    return AnyView(LoginView()
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true))
                case .Register:
                    return AnyView(RegisterView()
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true))
                case .Verify(let code):
                    return AnyView(VerifyView(code: code)
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true))
                }
            }.onOpenURL { url in
                // URL after domain like "/verify"
                let relevantURLSubstring: String = url.host ?? ""
                // Parameter like "123456" following "/verify"
                let path: String = url.path.substring(fromIndex: 1)

                switch relevantURLSubstring {
                case "welcome": pilot.push(.Welcome)
                case "verify": pilot.push(.Verify(code: path))
                default: pilot.push(.Welcome)
                }
            }
        }
    }
}
