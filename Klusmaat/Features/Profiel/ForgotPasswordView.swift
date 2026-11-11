//
//  SwiftUIView.swift
//  Klusmaat
//
//  Created by Floris Ellenbroek on 05/11/2026.
//

import SwiftUI

struct ForgotPasswordView: View {

    @State private var email = ""
    @FocusState private var isFieldFocused: String?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()

                VStack {
                    Text("Wachtwoord vergeten")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)

                    Text(
                        "Voer je e-mailadres in om een herstel link te ontvangen"
                    )
                    .foregroundColor(Color.softText)
                    .multilineTextAlignment(.center)

                    TextField("E-mailadres", text: $email)
                        .textContentType(.emailAddress)
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
                        .padding(.top, 10)

                    NavigationLink(destination: MailSendView()) {
                        //TODO link sturen
                        Text("Verstuur link")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.greenPrimary)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                    .disabled(!email.isValidEmail)
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
        }
    }
}

#Preview {
    ForgotPasswordView()
}
