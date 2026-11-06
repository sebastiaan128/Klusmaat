//
//  KlusmaatTabBar.swift
//  Klusmaat
//
//  Eigen tabbalk: een Liquid Glass-capsule met de vier tabs en daarnaast een losse salie glazen knop om een klus
//  te plaatsen. De native TabView zet zo'n losse knop niet naast de tabs, vandaar een eigen balk.
//

import SwiftUI

struct KlusmaatTabBar: View {
    @Binding var selectie: AppTab
    /// Swipe-voortgang tussen de tabs: 0 is de eerste tab, 1 de tweede, 0,5 halverwege. Hier volgt de selectie-pil op.
    var voortgang: SwipeVoortgang
    let onPlaatsen: () -> Void

    /// Hoogte van de balk (de plaatsknop), plus wat lucht erboven.
    static let hoogte: CGFloat = 66 + 12

    var body: some View {
        GlassEffectContainer(spacing: 12) {
            HStack(spacing: 12) {
                HStack(spacing: 0) {
                    ForEach(AppTab.allCases, id: \.self) { tab in
                        tabKnop(tab)
                    }
                }
                .background { selectiePil }
                .padding(6)
                .glassEffect(.regular.interactive(), in: .capsule)

                Button(action: onPlaatsen) {
                    Image(systemName: "plus")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(Color.klusGroen)
                        .frame(width: 66, height: 66)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.tint(.klusSalie).interactive(), in: .circle)
                .accessibilityLabel("Klus plaatsen")
            }
        }
        .padding(.horizontal, 20)
    }

    /// Volgt de swipe live en rekt halverwege twee tabs iets uit, zodat hij als een druppel meebeweegt.
    private var selectiePil: some View {
        GeometryReader { geo in
            let aantal = CGFloat(AppTab.allCases.count)
            let tabBreedte = geo.size.width / aantal
            let positie = min(max(voortgang.waarde, 0), aantal - 1)
            let rek = 1 + 0.35 * sin(.pi * (positie - positie.rounded(.down)))

            Capsule()
                .fill(Color.klusGroen.opacity(0.12))
                .frame(width: tabBreedte * rek, height: geo.size.height)
                .offset(x: positie * tabBreedte - tabBreedte * (rek - 1) / 2)
        }
    }

    private func tabKnop(_ tab: AppTab) -> some View {
        // Kleur wisselt zodra de pil over de helft is, niet pas als de swipe klaar is
        let geselecteerd = AppTab.allCases.firstIndex(of: tab) == Int(voortgang.waarde.rounded())

        return Button {
            withAnimation(.snappy) { selectie = tab }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: tab.icoon)
                    .font(.system(size: 20, weight: geselecteerd ? .semibold : .regular))
                    .symbolVariant(geselecteerd ? .fill : .none)
                Text(tab.titel)
                    .font(.system(size: 11, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(geselecteerd ? Color.klusGroen : Color.klusTekst)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .contentShape(.capsule)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(geselecteerd ? .isSelected : [])
    }
}

#Preview {
    @Previewable @State var selectie = AppTab.zoeken
    KlusmaatTabBar(selectie: $selectie, voortgang: SwipeVoortgang(), onPlaatsen: {})
}
