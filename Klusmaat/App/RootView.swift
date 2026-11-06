import SwiftUI

struct RootView: View {
    @State private var geselecteerdeTab: AppTab = .zoeken
    @State private var toontPlaatsen = false
    @State private var filters = KlusFilters()

    var body: some View {
        TabView(selection: tabSelectie) {
            tab(.zoeken) {
                HomeView(
                    filters: $filters,
                    onToonResultaten: { geselecteerdeTab = .overzicht },
                    onProfiel: { geselecteerdeTab = .profiel },
                    onPlaatsen: { toontPlaatsen = true }
                )
            }
            tab(.overzicht) { OverzichtView(filters: $filters) }
            tab(.reacties) { BerichtenView() }
            tab(.profiel) { ProfielView() }
            tab(.plaatsen) { Color.clear }
        }
        .tint(.klusGroen)
        .sheet(isPresented: $toontPlaatsen) {
            PlaatsenView()
        }
    }

    private func tab(_ tab: AppTab, @ViewBuilder inhoud: () -> some View) -> some TabContent<AppTab> {
        Tab(tab.titel, systemImage: tab.icoon, value: tab, content: inhoud)
    }

    /// Plaatsen is geen echte tab: de geselecteerde tab blijft staan en de sheet gaat open.
    private var tabSelectie: Binding<AppTab> {
        Binding {
            geselecteerdeTab
        } set: { tab in
            if tab == .plaatsen {
                toontPlaatsen = true
            } else {
                geselecteerdeTab = tab
            }
        }
    }
}

#Preview {
    RootView()
}
