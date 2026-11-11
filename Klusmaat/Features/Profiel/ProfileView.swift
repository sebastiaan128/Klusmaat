//
//  ProfileView.swift
//  Klusmaat
//
//  Created by Floris Ellenbroek on 06/11/2026.
//

import SwiftUI

struct ProfileView: View {
    @State private var username = "Sanne de Vries"
    @State private var email = "sanne@voorbeeld.nl"
    @State private var location = "Utrecht"
    @State private var signupDate = "maart 2026"
    @State private var rating = "4.8"
    @State private var reviews = "12"
    @State private var klussenPosted = "5"
    @State private var amountHelped = "9"
    @State private var aboutMe = "Handig met verf en gereedschap en ik vind het leuk om buren te helpen. Vooral in het weekend beschikbaar."

    var body: some View {
        NavigationStack {
            let firstCharUsername: String = String(username.first ?? " ")
            let firstCharLastname: String = String(
                username.split(separator: " ").last?.first ?? " "
            )

            ZStack {
                Color.background
                    .ignoresSafeArea()

                VStack {
                    Text(
                        "\(String(firstCharUsername))\(String(firstCharLastname))"
                    )
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.greenPrimary)
                    .padding(50)
                    .background(Color.greenBackground)
                    .cornerRadius(100)

                    Text(username)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack {
                        Image(systemName: "pin")
                        Text(location)
                        Text("·  Lid sinds")
                        Text(signupDate)

                    }
                    .foregroundColor(Color.softText)

                    HStack {
                        Image(systemName: "star.fill")
                        Text(rating + " · " + reviews + " reviews")
                    }
                    .padding(12)
                    .background(Color.greenBackground)
                    .cornerRadius(100)
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)

                    HStack {
                        VStack {
                            Text(klussenPosted)
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Klussen geplaatst")
                                .foregroundColor(Color.softText)
                        }
                        .frame(width: 180, height: 80)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.border, lineWidth: 1)
                        )

                        VStack {
                            Text(amountHelped)
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Keer geholpen")
                                .foregroundColor(Color.softText)
                        }
                        .frame(width: 180, height: 80)

                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.border, lineWidth: 1)
                        )
                    }
                    VStack(alignment: .leading) {
                        HStack(spacing: 236) {
                            Text("Over mij")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(alignment: .leading)
                            
                            NavigationLink(destination: EditProfileView()) {
                                Image(systemName: "pencil")
                            }
                            .foregroundColor(Color.softText)
                            .font(.system(size: 20))


                        }
                        Text(aboutMe)
                            .font(.body)
                            .padding(.top, 1)

                    }
                    .frame(width: 350)
                    .padding(15)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.border, lineWidth: 1)
                    )
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 125) {
                            Text("Persoonsgegevens")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            NavigationLink(destination: EditProfileView()) {
                                Image(systemName: "pencil")
                            }
                            .foregroundColor(Color.softText)
                            .font(.system(size: 20))


                        }
                        HStack(spacing: 20){
                            VStack(alignment: .leading){
                                Text("Naam")
                                    .foregroundColor(Color.softText)
                                    .fontWeight(.semibold)
                                Text(username)
                                    .font(.system(size: 20))
                            }
                            .padding(.top, 2)
                            .frame(alignment: .leading)
                            
                            VStack(alignment: .leading){
                                Text("E-mailadres")
                                    .foregroundColor(Color.softText)
                                    .fontWeight(.semibold)
                                Text(email)
                                    .font(.system(size: 20))
                            }
                            .padding(.top, 2)
                            .frame(alignment: .leading)

                        }
                        VStack(alignment: .leading){
                            Text("Woonplaats")
                                .foregroundColor(Color.softText)
                                .fontWeight(.semibold)
                            Text(location)
                                .font(.system(size: 20))
                        }
                        .padding(.top, 4)
                        .frame(alignment: .leading)

                    }
                    .frame(width: 350)
                    .padding(15)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.border, lineWidth: 1)
                    )
                     
                    Button {
                        // logout code
                    } label: {
                        NavigationLink(destination: LoginView()) {
                            HStack(spacing: 15){
                                Image(systemName: "iphone.and.arrow.forward.outward")
                                
                                Text("Uitloggen")
                            }
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(Color.errorRed)
                        .padding(25)
                        .frame(maxWidth: 380)
                        .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.errorRed, lineWidth: 2)
                            )
                        
                    }
                    .padding(.top, 10)

                }
                .frame(maxHeight: .infinity, alignment: .top)
                
            }
            
        }
    }
}

#Preview {
    ProfileView()
}
