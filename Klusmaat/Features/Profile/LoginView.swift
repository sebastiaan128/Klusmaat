import SwiftUI

struct LoginView: View {
    var onCreateAccount: (() -> Void)?

    private enum Field: Hashable {
        case email
        case password
    }

    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordHidden = true
    @State private var isSigningIn = false
    @State private var errorMessage: String?
    @FocusState private var focusedField: Field?

    private var canSignIn: Bool {
        email.isValidEmail && password.count >= 6 && !isSigningIn
    }

    var body: some View {
        ProfilePage {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welkom terug")
                        .font(.title.bold())
                    Text("Heb je al een account? Log hier in.")
                        .font(.body)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.bottom, 28)

                VStack(spacing: 12) {
                    AuthInput(icon: "envelope", isFocused: focusedField == .email) {
                        TextField("E-mailadres", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .password }
                    }

                    AuthInput(icon: "lock", isFocused: focusedField == .password, hasTrailingControl: true) {
                        Group {
                            if isPasswordHidden {
                                SecureField("Wachtwoord", text: $password)
                            } else {
                                TextField("Wachtwoord", text: $password)
                            }
                        }
                        .textContentType(.password)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.go)
                        .onSubmit(signIn)

                        Button {
                            isPasswordHidden.toggle()
                        } label: {
                            Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                                .foregroundStyle(Color.textSecondary)
                                .frame(minWidth: 44, minHeight: 44)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(isPasswordHidden ? "Wachtwoord tonen" : "Wachtwoord verbergen")
                    }
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

                NavigationLink { ForgotPasswordView() } label: {
                    Text("Wachtwoord Vergeten?")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Color.brandGreen)
                        .frame(minHeight: 44)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 4)
                .padding(.bottom, 12)

                if let errorMessage {
                    Label(errorMessage, systemImage: "exclamationmark.circle")
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 16)
                }

                Button(action: signIn) {
                    HStack(spacing: 10) {
                        if isSigningIn { ProgressView().tint(.white) }
                        Text(isSigningIn ? "Bezig met inloggen..." : "Inloggen")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 40)
                }
                .buttonStyle(.glassProminent)
                .tint(.brandGreen)
                .disabled(!canSignIn)

                AuthDivider()
                GoogleSignInLink()

                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 6) {
                        Text("Nog geen account?")
                        registrationLink
                    }
                    VStack(spacing: 4) {
                        Text("Nog geen account?")
                        registrationLink
                    }
                }
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
            }
        }
        .navigationTitle("Inloggen")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var registrationLink: some View {
        let label = Text("Account aanmaken")
            .fontWeight(.semibold)
            .foregroundStyle(Color.brandGreen)
            .frame(minHeight: 44)
        if let onCreateAccount {
            Button(action: onCreateAccount) { label }
        } else {
            NavigationLink { RegisterView() } label: { label }
        }
    }

    private func signIn() {
        guard canSignIn else { return }
        focusedField = nil
        errorMessage = nil
        isSigningIn = true
        AuthService().signIn(email: email, password: password) { error in
            isSigningIn = false
            errorMessage = error
            if error == nil { AppState.shared.show("Je bent ingelogd", icon: "person.crop.circle.badge.checkmark") }
        }
    }
}

#Preview {
    NavigationStack { LoginView() }
}
