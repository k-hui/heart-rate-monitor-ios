//
//  HeartRateMonitorApp.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/26/21.
//

import SwiftUI

@main
struct HeartRateMonitorApp: App {
    @Environment(\.scenePhase) var scenePhase

    @ObservedObject private var userManager = UserManager()
    @ObservedObject private var apiManager = ApiManager()

    init() {
        if AppConfig.mock {
            userManager = MockUserManager()
            apiManager = MockApiManager()
        }

        // auto loggedIn if token exist
        if let token = UserDefaultsUtils.loadToken() {
            Logger.d("token=\(token)")
            userManager.login(token: token)
            apiManager.token = token
        }
    }

    var body: some Scene {
        WindowGroup {
            if userManager.isLogged {
                HomeView()
                    .environmentObject(userManager)
                    .environmentObject(apiManager)
            } else {
                LoginView()
                    .environmentObject(userManager)
                    .environmentObject(apiManager)
            }
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                Logger.d("active")
            case .background:
                Logger.d("background")
            case .inactive:
                Logger.d("inactive")
            @unknown default:
                Logger.d("unknown")
            }
        }
    }

}
