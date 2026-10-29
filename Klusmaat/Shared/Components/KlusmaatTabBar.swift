//
//  KlusmaatTabBar.swift
//  Klusmaat
//
//  Eigen tabbalk: een glazen capsule met de vier tabs en daarnaast een losse oranje knop om een klus te plaatsen.
//

import SwiftUI

extension Color {
    static let klusGroen = Color(red: 0.17, green: 0.36, blue: 0.30)
    static let klusOranje = Color(red: 0.93, green: 0.67, blue: 0.36)
}

struct KlusmaatTabBar: View {
    @Binding var selectie: AppTab
    let onPlaatsen: () -> Void

    @Namespace private var selectieAnimatie

    var body: some View {
        GlassEffectContainer(spacing: 12) {
            HStack(spacing: 12) {
                HStack(spacing: 0) {
                    ForEach(AppTab.allCases, id: \.self) { tab in
                        tabKnop(tab)
                    }
                }
                .padding(6)
                .glassEffect(.regular, in: .capsule)

                Button(action: onPlaatsen) {
                    Image(systemName: "plus")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(.black)
                        .frame(width: 68, height: 68)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.tint(.klusOranje).interactive(), in: .circle)
                .accessibilityLabel("Klus plaatsen")
            }
        }
        .padding(.horizontal, 20)
    }

    private func tabKnop(_ tab: AppTab) -> some View {
        let geselecteerd = selectie == tab

        return Button {
            withAnimation(.snappy) { selectie = tab }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: tab.icoon)
                    .font(.system(size: 20, weight: geselecteerd ? .semibold : .regular))
                Text(tab.titel)
                    .font(.system(size: 11, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(geselecteerd ? Color.klusGroen : Color.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background {
                if geselecteerd {
                    Capsule()
                        .fill(Color.klusGroen.opacity(0.12))
                        .matchedGeometryEffect(id: "selectie", in: selectieAnimatie)
                }
            }
            .contentShape(.capsule)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(geselecteerd ? .isSelected : [])
    }
}

#Preview {
    @Previewable @State var selectie = AppTab.zoeken
    KlusmaatTabBar(selectie: $selectie, onPlaatsen: {})
}
