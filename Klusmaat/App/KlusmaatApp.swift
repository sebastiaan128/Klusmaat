//
//  KlusmaatApp.swift
//  Klusmaat
//
//  Entry point van de app. App/ bevat alles wat de app opstart.
//

import SwiftUI

@main
struct KlusmaatApp: App {
    init() {
        Lettertypen.registreer()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
