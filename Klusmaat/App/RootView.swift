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

            Tab(value: .plaatsen, role: .prominent) {
                Color.clear
            } label: {
                tabLabel(.plaatsen)
            }
        }
        .tint(.klusGroen)
        .sheet(isPresented: $toontPlaatsen) {
            PlaatsenView()
        }
    }

    private func tab(_ tab: AppTab, @ViewBuilder inhoud: () -> some View) -> some TabContent<AppTab> {
        Tab(value: tab, content: inhoud) {
            tabLabel(tab)
        }
    }

    private func tabLabel(_ tab: AppTab) -> some View {
        Label {
            Text(tab.titel)
        } icon: {
            Image(uiImage: icoon(tab.icoon))
        }
    }

    private func icoon(_ naam: String) -> UIImage {
        let instelling = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        return UIImage(systemName: naam, withConfiguration: instelling) ?? UIImage()
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
