import SwiftUI

struct RootView: View {
    @State private var geselecteerdeTab: AppTab = .zoeken
    @State private var toontPlaatsen = false
    @State private var swipe = SwipeVoortgang()

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
            swipe.waarde = voortgang
        }
        .safeAreaInset(edge: .bottom) {
            KlusmaatTabBar(selectie: $geselecteerdeTab, voortgang: swipe) {
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
        case .zoeken:
            HomeView(onProfiel: { withAnimation(.snappy) { geselecteerdeTab = .profiel } }, onPlaatsen: { toontPlaatsen = true })
        case .overzicht: OverzichtView()
        case .reacties: BerichtenView()
        case .profiel: ProfielView()
        }
    }

    private var scrollPositie: Binding<AppTab?> {
        Binding {
            geselecteerdeTab
        } set: { tab in
            if let tab { geselecteerdeTab = tab }
        }
    }
}

/// Swipe-voortgang in een eigen object: alleen de tabbalk leest hem, zodat de schermen
/// niet bij elk frame van een swipe opnieuw worden opgebouwd.
@Observable
final class SwipeVoortgang {
    var waarde: CGFloat = 0
}

#Preview {
    RootView()
}
