//
//  RegisterView.swift
//  Klusmaat
//
//  Created by Floris Ellenbroek on 05/11/2026.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordHidden: Bool = true
    @FocusState private var isFieldFocused: String?
    @State private var isChecked = false
    @State private var navigateToHome = false
    @State private var errorMessage: String?

    var loginButtonActive: Bool {
        email.isValidEmail && password.count >= 6 && firstName.count > 0
            && lastName.count > 0 && isChecked
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()

                VStack {
                    Text("Maak je account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    Text(
                        "Maak je account aan, plaats klussen en help je buren."
                    )
                    .padding(.top, -10)
                    .foregroundColor(Color.softText)
                    .padding(.bottom, 50)
                    .multilineTextAlignment(.center)

                    HStack(spacing: 10) {
                        Image(systemName: "person")
                            .foregroundColor(Color.softText)
                        TextField("Voornaam", text: $firstName)
                            .textContentType(.name)
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
                    .focused($isFieldFocused, equals: "firstName")
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                isFieldFocused == "firstName"
                                    ? Color.greenPrimary : Color.border,
                                lineWidth: 1
                            )
                    )
                    .padding(.bottom, 10)

                    HStack(spacing: 10) {
                        Image(systemName: "person")
                            .foregroundColor(Color.softText)
                        TextField("Achternaam", text: $lastName)
                            .textContentType(.name)
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
                    .focused($isFieldFocused, equals: "lastName")
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                isFieldFocused == "lastName"
                                    ? Color.greenPrimary : Color.border,
                                lineWidth: 1
                            )
                    )
                    .padding(.bottom, 10)

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
                                isFieldFocused == "e-mail"
                                    ? Color.greenPrimary : Color.border,
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
                            Image(
                                systemName: isPasswordHidden
                                    ? "eye.slash" : "eye"
                            )
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
                    .padding(.top, 1)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .focused($isFieldFocused, equals: "password")
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                isFieldFocused == "password"
                                    ? Color.greenPrimary : Color.border,
                                lineWidth: 1
                            )
                    )
                    HStack(spacing: 5) {
                        Button {
                            isChecked.toggle()
                        } label: {
                            Image(
                                systemName: isChecked
                                    ? "checkmark.square.fill" : "square"
                            )
                            .font(.system(size: 24))
                            .foregroundColor(Color.greenPrimary)
                        }
                        .buttonStyle(.plain)

                        Text("Ik ga akkoord met de")

                        NavigationLink(destination: HomeView(filters: .constant(KlusFilters()))) {
                            Text("Algemene voorwaarden")
                                .foregroundStyle(Color.greenPrimary)
                                .underline()
                                .fixedSize()
                        }
                    }
                    .font(.system(size: 12))
                    .padding(.top, 20)

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)
                    }

                    Button {
                        errorMessage = nil
                        AuthService().registerUser(
                            email: email,
                            password: password
                        ) { error in
                            errorMessage = error
                            navigateToHome = error == nil
                        }
                    } label: {
                        Text("Registreren")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.greenPrimary)
                            .cornerRadius(10)
                            .padding(.top, 10)
                    }
                    .buttonStyle(.plain)
                    .disabled(!loginButtonActive)

                    HStack {
                        Rectangle()
                            .frame(height: 1)

                        Text("of")

                        Rectangle()
                            .frame(height: 1)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)

                    NavigationLink(destination: HomeView(filters: .constant(KlusFilters()))) {
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

                    HStack {
                        Text("Al een account?")
                        NavigationLink(destination: LoginView()) {
                            Text("Inloggen")
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
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView(filters: .constant(KlusFilters()))
            }
        }
    }
}

#Preview {
    RegisterView()
}
