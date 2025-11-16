// AppDelegate.swift
// Global configuration: Firebase + Google Maps

import UIKit
import FirebaseCore
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        // 1) Start Firebase
        FirebaseApp.configure()
        
        // 2) Provide your Google Maps API key
        //    TODO: replace the string with your real key
        GMSServices.provideAPIKey("YOUR_API_KEY")
        
        return true
    }
}
