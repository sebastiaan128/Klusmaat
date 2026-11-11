//
//  EditProfileView.swift
//  Klusmaat
//
//  Created by Floris Ellenbroek on 06/11/2026.
//

import SwiftUI

struct EditProfileView: View {
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
                ScrollView {
                    HStack(spacing: 30){
                        NavigationLink(destination: ProfileView()) {
                            Text("Annuleer")
                                .padding(.leading, 10)
                        }
                        Text("Profiel bewerken")
                            .fontWeight(.bold)
                            .font(.system(size: 20))

                        Button {
                            // save code
                        } label: {
                            NavigationLink(destination: ProfileView()) {
                                Text("Opslaan")
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    
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
                            HStack(spacing: 230) {
                                Text("Over mij")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .frame(alignment: .leading)
                                
                            }
                            TextField(aboutMe, text: $aboutMe, axis: .vertical)
                                .padding(.top, 1)
                                .lineSpacing(3)
                                .fontWeight(.semibold)
                                .lineLimit(3...10)
                                .padding(12)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .background(Color.inputBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.border, lineWidth: 1)
                                )
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
                                
                            }
                            
                                VStack(alignment: .leading){
                                    Text("Naam")
                                        .foregroundColor(Color.softText)
                                        .fontWeight(.semibold)
                                        .padding(.top, 10)
                                    TextField(username, text: $username)
                                        .font(.system(size: 20))
                                        .padding(8)
                                        .background(Color.inputBackground)
                                        .fontWeight(.semibold)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.border, lineWidth: 1)
                                        )
                                
                                
                                VStack(alignment: .leading){
                                    Text("Woonplaats")
                                        .padding(.top, 10)
                                        .foregroundColor(Color.softText)
                                        .fontWeight(.semibold)
                                    TextField(location, text: $location)
                                        .font(.system(size: 20))
                                        .fontWeight(.semibold)
                                        .padding(8)
                                        .background(Color.inputBackground)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.border, lineWidth: 1)
                                        )
                                    
                                    Text("E-mailadres")
                                        .padding(.top, 10)
                                        .foregroundColor(Color.softText)
                                        .fontWeight(.semibold)
                                    TextField(email, text: $email)
                                        .font(.system(size: 20))
                                        .padding(8)
                                        .background(Color.inputBackground)
                                        .fontWeight(.semibold)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.border, lineWidth: 1)
                                        )
                                }
                                .padding(.top, 2)
                                .frame(alignment: .leading)
                                
                            }
                        }
                        .frame(width: 350)
                        .padding(15)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.border, lineWidth: 1)
                        )
                        
                        Button {
                            // save code
                        } label: {
                                HStack(spacing: 15){
                                    NavigationLink(destination: ProfileView()) {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 20))
                                        
                                        Text("Opslaan")
                                            .font(.system(size: 20))
                                    }
                                }
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(25)
                            .frame(maxWidth: 380)
                            .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.greenPrimary)
                                        .stroke(Color.greenPrimary, lineWidth: 2)
                                )
                            
                        }
                        .padding(.top, 10)
                        
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    
                }
            }
        }
    }
}

#Preview {
    EditProfileView()
}
