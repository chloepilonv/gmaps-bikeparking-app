// BikeParkingApp.swift
// SwiftUI entry point for the app

import SwiftUI
import FirebaseCore

@main
struct BikeParkingApp: App {
    
    // Connect UIKit AppDelegate to SwiftUI lifecycle
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
