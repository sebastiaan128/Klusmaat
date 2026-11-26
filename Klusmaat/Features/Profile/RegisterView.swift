import SwiftUI

struct RegisterView: View {
    var onSignIn: (() -> Void)?

    private enum Field: Hashable {
        case firstName
        case lastName
        case email
        case password
    }

    @Environment(\.dismiss) private var dismiss
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordHidden = true
    @State private var hasAcceptedTerms = false
    @State private var isRegistering = false
    @State private var errorMessage: String?
    @FocusState private var focusedField: Field?

    private var canRegister: Bool {
        !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && email.isValidEmail && password.count >= 6 && hasAcceptedTerms && !isRegistering
    }

    var body: some View {
        ProfilePage {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nieuw hier? Maak een account")
                        .font(.title.bold())
                    Text("Gratis. Plaats klussen of help je buren en verdien wat bij.")
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.bottom, 28)

                VStack(spacing: 12) {
                    AuthInput(icon: "person", isFocused: focusedField == .firstName) {
                        TextField("Voornaam", text: $firstName)
                            .textContentType(.givenName)
                            .textInputAutocapitalization(.words)
                            .focused($focusedField, equals: .firstName)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .lastName }
                    }
                    AuthInput(icon: "person", isFocused: focusedField == .lastName) {
                        TextField("Achternaam", text: $lastName)
                            .textContentType(.familyName)
                            .textInputAutocapitalization(.words)
                            .focused($focusedField, equals: .lastName)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .email }
                    }
                    AuthInput(icon: "envelope", isFocused: focusedField == .email) {
                        TextField("E-mailadres", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
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
                        .textContentType(.newPassword)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.done)
                        .onSubmit { focusedField = nil }

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
                .autocorrectionDisabled()

                terms
                    .padding(.vertical, 16)

                if let errorMessage {
                    Label(errorMessage, systemImage: "exclamationmark.circle")
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 16)
                }

                Button(action: register) {
                    HStack(spacing: 10) {
                        if isRegistering { ProgressView().tint(.white) }
                        Text(isRegistering ? "Account aanmaken..." : "Account aanmaken")
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 40)
                }
                .buttonStyle(.glassProminent)
                .tint(.brandGreen)
                .disabled(!canRegister)

                AuthDivider()
                GoogleSignInLink()

                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 6) {
                        Text("Al een account?")
                        loginButton
                    }
                    VStack(spacing: 4) {
                        Text("Al een account?")
                        loginButton
                    }
                }
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
            }
        }
        .navigationTitle("Account aanmaken")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var terms: some View {
        HStack(spacing: 4) {
            Button {
                hasAcceptedTerms.toggle()
            } label: {
                Image(systemName: hasAcceptedTerms ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundStyle(Color.brandGreen)
                    .frame(minWidth: 44, minHeight: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Ik ga akkoord met de Algemene Voorwaarden")
            .accessibilityValue(hasAcceptedTerms ? "Geselecteerd" : "Niet geselecteerd")

            NavigationLink { HomeView() } label: {
                Text("Ik ga akkoord met de \(Text("Algemene Voorwaarden").fontWeight(.medium).foregroundStyle(Color.brandGreen))")
                    .font(.footnote)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            }
            .buttonStyle(.plain)
        }
    }

    private var loginButton: some View {
        Button("Inloggen") {
            if let onSignIn { onSignIn() } else { dismiss() }
        }
            .fontWeight(.semibold)
            .foregroundStyle(Color.brandGreen)
            .frame(minHeight: 44)
    }

    private func register() {
        guard canRegister else { return }
        focusedField = nil
        errorMessage = nil
        isRegistering = true
        AuthService().registerUser(email: email, password: password) { error in
            isRegistering = false
            errorMessage = error
            if error == nil { AppState.shared.show("Welkom! Je account is aangemaakt", icon: "party.popper.fill") }
        }
    }
}

#Preview {
    NavigationStack { RegisterView() }
}
