//
//  RootView.swift
//  Klusmaat
//
//  Eerste scherm van de app. De tabs liggen naast elkaar in een paging-ScrollView, zodat je ertussen kunt swipen;
//  KlusmaatTabBar volgt de swipe live en scrollt bij een tik naar de juiste tab. De content scrolt onder het glas door.
//

import SwiftUI

struct RootView: View {
    @State private var geselecteerdeTab: AppTab = .zoeken
    @State private var toontPlaatsen = false
    @State private var swipeVoortgang: CGFloat = 0

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    scherm(voor: tab)
                        .containerRelativeFrame([.horizontal, .vertical])
                        .id(tab)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .scrollPosition(id: scrollPositie)
        .onScrollGeometryChange(for: CGFloat.self) { geometrie in
            guard geometrie.containerSize.width > 0 else { return 0 }
            return geometrie.contentOffset.x / geometrie.containerSize.width
        } action: { _, voortgang in
            swipeVoortgang = voortgang
        }
        .safeAreaInset(edge: .bottom) {
            KlusmaatTabBar(selectie: $geselecteerdeTab, voortgang: swipeVoortgang) {
                toontPlaatsen = true
            }
        }
        .sheet(isPresented: $toontPlaatsen) {
            PlaatsenView()
        }
    }

    @ViewBuilder
    private func scherm(voor tab: AppTab) -> some View {
        switch tab {
        case .zoeken: HomeView()
        case .mijnKlussen: MijnKlussenView()
        case .reacties: BerichtenView()
        case .profiel: ProfielView()
        }
    }

    /// Koppelt de scrollpositie aan de geselecteerde tab, zodat swipen en tikken elkaar volgen.
    private var scrollPositie: Binding<AppTab?> {
        Binding {
            geselecteerdeTab
        } set: { tab in
            if let tab { geselecteerdeTab = tab }
        }
    }
}

#Preview {
    RootView()
}
