import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordHidden: Bool = true
    @FocusState private var isFieldFocused: String?
    @State private var errorMessage: String?
    @State private var navigateToProfile = false

    var loginButtonActive: Bool {
        email.isValidEmail && password.count > 5
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()

                VStack {
                    Text("Welkom Terug")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    Text("Log in bij KlusMaat")
                        .padding(.top, -10)
                        .foregroundColor(Color.softText)
                        .padding(.bottom, 50)
                    
                    HStack(spacing: 10) {
                        Image(systemName: "envelope")
                            .foregroundColor(Color.softText)
                        TextField("E-mailadres", text: $email)
                            .textContentType(.emailAddress)
                    }
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 15)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .focused($isFieldFocused, equals: "e-mail")
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    isFieldFocused == "e-mail" ? Color.greenPrimary : Color.border,
                                    lineWidth: 1
                            )
                        )
                        .padding(.bottom, 10)
                    
                    HStack(spacing: 10) {
                        Image(systemName: "lock")
                            .foregroundColor(Color.softText)
                        if isPasswordHidden {
                            SecureField("Wachtwoord", text: $password)
                                .textContentType(.password)
                        } else {
                            TextField("Wachtwoord", text: $password)
                                .textContentType(.password)

                        }
                        Button {
                            isPasswordHidden.toggle()
                        } label: {
                            Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                                .foregroundColor(Color.softText)
                                .padding(.trailing, 20)
                        }
                    }
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 15)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                        .padding(.top, 1)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .focused($isFieldFocused, equals: "password")
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    isFieldFocused == "password" ? Color.greenPrimary : Color.border,
                                    lineWidth: 1
                            )
                        )
                    
                    
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Wachtwoord vergeten")
                            .foregroundStyle(Color.greenPrimary)
                            .underline()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 0)
                    }
                    .padding(.bottom, 20)
                    .padding(.top, 5)

                        if let errorMessage {
                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 10)
                        }

                        Button {
                            errorMessage = nil
                            AuthService().signIn(email: email, password: password) { error in
                                errorMessage = error
                                navigateToProfile = error == nil
                            }
                        } label: {
                            Text("Inloggen")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.greenPrimary)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                        .disabled(!loginButtonActive)

                    
                    HStack() {
                        Rectangle()
                            .frame(height: 1)

                        Text("of")

                        Rectangle()
                            .frame(height: 1)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)

                    NavigationLink(destination: HomeView()) {
                        HStack(spacing: 10) {
                            Image("Google_Symbol_0")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)

                            Text("Inloggen met Google")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.border, lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    HStack{
                        Text("Nog geen account?")
                        NavigationLink(destination: RegisterView()) {
                            Text("Aanmelden")
                                .foregroundStyle(Color.greenPrimary)
                                .underline()
                                .padding(.trailing, 0)
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(25)
                .frame(width: 350)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.border, lineWidth: 1)
                )
            }
            .navigationDestination(isPresented: $navigateToProfile) {
                ProfileView()
            }
        }
    }

}

#Preview {
    LoginView()
}
