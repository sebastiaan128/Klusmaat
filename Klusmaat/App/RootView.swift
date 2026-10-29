//
//  RootView.swift
//  Klusmaat
//
//  Eerste scherm van de app: de tabbalk met de features. De camera-knop uit de Android-navbar
//  is hier een gewone middelste tab, zodat we de native Liquid Glass-tabbalk van iOS houden.
//

import SwiftUI

struct RootView: View {
    @State private var geselecteerdeTab: AppTab = .home

    var body: some View {
        TabView(selection: $geselecteerdeTab) {
            Tab("Home", systemImage: "house.fill", value: .home) {
                HomeView()
            }
            Tab("Overzicht", systemImage: "list.bullet", value: .overzicht) {
                OverzichtView()
            }
            Tab("Plaatsen", systemImage: "camera.fill", value: .plaatsen) {
                PlaatsenView()
            }
            Tab("Chat", systemImage: "bubble.left.and.bubble.right.fill", value: .chat) {
                BerichtenView()
            }
            Tab("Account", systemImage: "person.fill", value: .account) {
                ProfielView()
            }
        }
    }
}

#Preview {
    RootView()
}
