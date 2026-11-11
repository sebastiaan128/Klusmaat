//
//  KlusmaatApp.swift
//  Klusmaat
//
//  Entry point van de app. App/ bevat alles wat de app opstart.
//

import SwiftUI
import FirebaseCore

@main
struct KlusmaatApp: App {
    
    init() {
            FirebaseApp.configure()
        }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
    
