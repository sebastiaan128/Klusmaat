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
    
