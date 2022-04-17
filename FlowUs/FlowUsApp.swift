//
//  FlowUsApp.swift
//  FlowUs
//
//  Created by Lucas Goldner on 18.07.21.
//

import Firebase
import L10n_swift
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        Configuration.shared.setupConfig()
        return true
    }
}

@main
struct FlowUsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ZStack {
                LinearGradientPreview()
                ScrollView {
                    VStack {
                        CountryInput()
                        CommonText(text: "hello.world".l10n())
                        TextInput()
                        TextInputDouble()
                    }
                }.keyboardAware()
            }
        }
    }
}
