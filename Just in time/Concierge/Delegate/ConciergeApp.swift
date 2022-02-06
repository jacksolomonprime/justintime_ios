//
//  ConciergeApp.swift
//  Concierge
//
//  Created by Jack A Solomon on 05/02/2022.
//

import SwiftUI
import UIKit

// no changes in your AppDelegate class
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        LocationManagerService.shared.startMonitoringChanges()
        return true
//
//        if launchOptions?[UIApplication.LaunchOptionsKey.location] != nil {
//            print("We get \(launchOptions?[UIApplication.LaunchOptionsKey.location])")
//            LocationManagerService.shared.startMonitoringChanges()
//        }
//        return true
    }
}

@main
struct ConciergeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ViewRouter()
        }
    }
}
