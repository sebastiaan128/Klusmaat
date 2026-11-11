//
//  MailSendView.swift
//  Klusmaat
//
//  Created by Floris Ellenbroek on 06/11/2026.
//

import SwiftUI

struct MailSendView: View {
    var body: some View {
        NavigationStack {
        ZStack {
                Color.background
                    .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "envelope.badge")
                        .font(.system(size: 100))
                    
                    Text("E-mail Verzonden")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    Text("Controleer je inbox voor een wachtwoord-resetlink.")
                        .foregroundColor(Color.softText)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Terug naar inloggen")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.greenPrimary)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
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
    MailSendView()
}
