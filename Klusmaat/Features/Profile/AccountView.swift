import FirebaseAuth
import SwiftUI

struct AccountView: View {
    enum Screen: String, CaseIterable, Identifiable {
        case register = "Account aanmaken"
        case login = "Inloggen"
        var id: Self { self }
    }

    @State private var screen = Screen.register
    @State private var isSignedIn = Auth.auth().currentUser != nil
    @State private var listener: AuthStateDidChangeListenerHandle?

    var body: some View {
        NavigationStack {
            Group {
                if isSignedIn {
                    ProfileView()
                } else {
                    Group {
                        switch screen {
                        case .register: RegisterView { switchTo(.login) }
                        case .login: LoginView { switchTo(.register) }
                        }
                    }
                    .safeAreaInset(edge: .top, spacing: 0) { switcher }
                }
            }
        }
        .id(isSignedIn)
        .onAppear {
            listener = Auth.auth().addStateDidChangeListener { _, user in
                isSignedIn = user != nil
            }
        }
        .onDisappear {
            if let listener { Auth.auth().removeStateDidChangeListener(listener) }
        }
    }

    private var switcher: some View {
        Picker("Kies", selection: $screen.animation(.snappy)) {
            ForEach(Screen.allCases) { Text($0.rawValue).tag($0) }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .background(Color.paper)
    }

    private func switchTo(_ screen: Screen) {
        withAnimation(.snappy) { self.screen = screen }
    }
}

#Preview {
    AccountView()
}
