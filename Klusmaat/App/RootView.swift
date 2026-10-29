//
//  RootView.swift
//  Klusmaat
//
//  Eerste scherm van de app. De standaard tabbalk is verborgen; KlusmaatTabBar neemt die plek in.
//

import SwiftUI

struct RootView: View {
    @State private var geselecteerdeTab: AppTab = .zoeken
    @State private var toontPlaatsen = false

    var body: some View {
        TabView(selection: $geselecteerdeTab) {
            Tab(value: AppTab.zoeken) {
                HomeView().toolbar(.hidden, for: .tabBar)
            }
            Tab(value: AppTab.mijnKlussen) {
                MijnKlussenView().toolbar(.hidden, for: .tabBar)
            }
            Tab(value: AppTab.reacties) {
                BerichtenView().toolbar(.hidden, for: .tabBar)
            }
            Tab(value: AppTab.profiel) {
                ProfielView().toolbar(.hidden, for: .tabBar)
            }
        }
        .safeAreaInset(edge: .bottom) {
            KlusmaatTabBar(selectie: $geselecteerdeTab) {
                toontPlaatsen = true
            }
        }
        .sheet(isPresented: $toontPlaatsen) {
            PlaatsenView()
        }
    }
}

#Preview {
    RootView()
}
