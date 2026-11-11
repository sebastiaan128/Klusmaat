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
            tab(.profiel) { LoginView() }

 
            Tab(AppTab.plaatsen.titel, systemImage: AppTab.plaatsen.icoon, value: .plaatsen, role: .prominent) {
                Color.clear
            }
        }
        .tint(.klusGroen)
        .sheet(isPresented: $toontPlaatsen) {
            PlaatsenView()
        }
    }

    private func tab(_ tab: AppTab, @ViewBuilder inhoud: () -> some View) -> some TabContent<AppTab> {
        Tab(tab.titel, systemImage: tab.icoon, value: tab, content: inhoud)
    }

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
