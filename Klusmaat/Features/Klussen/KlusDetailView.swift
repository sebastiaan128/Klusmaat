import SwiftUI

struct KlusDetailView: View {
    let klus: Klus

    @State private var helptMee = false
    @State private var bewaard = false

    private let overlap: CGFloat = 32

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                FotoGalerij(klus: klus, ruimteOnder: overlap)
                    .frame(height: 380)

                inhoud
                    .background(.white, in: UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32))
                    .padding(.top, -overlap)
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .background(.white)
        .safeAreaInset(edge: .bottom) { actieBalk }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        .toolbarVisibility(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    withAnimation(.snappy) { bewaard.toggle() }
                } label: {
                    Image(systemName: bewaard ? "heart.fill" : "heart")
                        .contentTransition(.symbolEffect(.replace))
                }
                .accessibilityLabel(bewaard ? "Niet meer bewaren" : "Bewaren")

                ShareLink(item: klus.titel) {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityLabel("Delen")
            }
        }
        .tint(.klusGroen)
    }

    private var inhoud: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 8) {
                label(klus.soort.rawValue)
                label("Open", bolletje: true)
                Text("Geplaatst \(klus.geplaatst)")
                    .font(.subheadline)
                    .foregroundStyle(Color.klusTekstZacht)
                    .lineLimit(1)
            }

            Text(klus.titel)
                .font(.title.bold())
                .foregroundStyle(Color.klusTekst)

            HStack(spacing: 10) {
                feit(icoon: "mappin.and.ellipse", waarde: klus.afstand, uitleg: "Afstand")
                feit(icoon: "calendar", waarde: klus.wanneer, uitleg: "Wanneer")
                feit(icoon: "clock", waarde: klus.duur.rawValue, uitleg: "Duur")
            }

            Text(klus.beschrijving)
                .font(.body)
                .lineSpacing(4)
                .foregroundStyle(Color.klusTekst)

            eigenaarKaart

            Text(helptMee
                 ? "Het adres wordt met je gedeeld in de chat."
                 : "Het exacte adres zie je zodra je aanbiedt te helpen.")
                .font(.footnote)
                .foregroundStyle(Color.klusTekstZacht)
                .contentTransition(.opacity)
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func label(_ tekst: String, bolletje: Bool = false) -> some View {
        HStack(spacing: 6) {
            if bolletje {
                Circle()
                    .fill(Color.klusGroen)
                    .frame(width: 7, height: 7)
            }
            Text(tekst)
        }
        .font(.subheadline.weight(.semibold))
        .foregroundStyle(Color.klusGroen)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.klusSalie.opacity(0.45), in: .capsule)
    }

    private func feit(icoon: String, waarde: String, uitleg: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Image(systemName: icoon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.klusGroen)
                .frame(height: 22)
                .padding(.bottom, 6)
            Text(waarde)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Color.klusTekst)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(uitleg)
                .font(.footnote)
                .foregroundStyle(Color.klusTekstZacht)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.klusCreme, in: .rect(cornerRadius: 18))
        .accessibilityElement(children: .combine)
    }

    private var eigenaarKaart: some View {
        HStack(spacing: 14) {
            Text(klus.eigenaar.prefix(1).uppercased())
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(Color.klusKoffie, in: .circle)

            VStack(alignment: .leading, spacing: 2) {
                Text(klus.eigenaar)
                    .font(.headline)
                    .foregroundStyle(Color.klusTekst)
                Text("Buurtbewoner · \(klus.afstand) van jou")
                    .font(.subheadline)
                    .foregroundStyle(Color.klusTekstZacht)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(Color.klusCreme, in: .rect(cornerRadius: 22))
    }

    private var actieBalk: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Vergoeding")
                    .font(.footnote)
                    .foregroundStyle(Color.klusTekstZacht)
                Text("€ \(klus.vergoeding)")
                    .font(.title2.bold())
                    .foregroundStyle(Color.klusTekst)
            }
            .padding(.leading, 12)

            Spacer()

            Button {
                withAnimation(.snappy) { helptMee.toggle() }
            } label: {
                Label(helptMee ? "Je helpt mee" : "Ik wil helpen",
                      systemImage: helptMee ? "checkmark" : "bubble.left")
                    .font(.headline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.glassProminent)
            .tint(helptMee ? .klusSalie : .klusGroen)
            .foregroundStyle(helptMee ? Color.klusGroen : .white)
            .accessibilityHint(helptMee ? "Trekt je aanbod in" : "Biedt aan om te helpen")
        }
        .padding(10)
        .glassEffect(.regular, in: .capsule)
        .padding(.horizontal, 20)
        .padding(.bottom, 4)
    }
}

private struct FotoGalerij: View {
    let klus: Klus
    let ruimteOnder: CGFloat

    @State private var huidige = 0

    var body: some View {
        Group {
            if klus.fotos.isEmpty {
                plaatshouder(icoon: klus.soort.icoon)
            } else {
                TabView(selection: $huidige) {
                    ForEach(klus.fotos.indices, id: \.self) { index in
                        KlusAfbeelding(url: klus.fotos[index], maxPunten: 440) {
                            plaatshouder(icoon: "photo")
                        }
                        .containerRelativeFrame(.horizontal)
                        .clipped()
                        .accessibilityLabel("Foto \(index + 1) van \(klus.fotos.count)")
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .overlay(alignment: .bottom) {
            if klus.fotos.count > 1 {
                HStack(spacing: 6) {
                    ForEach(klus.fotos.indices, id: \.self) { index in
                        Circle()
                            .fill(.white.opacity(index == huidige ? 1 : 0.5))
                            .frame(width: 7, height: 7)
                    }
                }
                .padding(.bottom, ruimteOnder + 16)
                .animation(.snappy, value: huidige)
                .accessibilityHidden(true)
            }
        }
    }

    private func plaatshouder(icoon: String) -> some View {
        Color.klusSalie.overlay {
            Image(systemName: icoon)
                .font(.system(size: 44))
                .foregroundStyle(Color.klusGroen.opacity(0.5))
                .padding(.bottom, ruimteOnder)
        }
    }
}

#Preview {
    NavigationStack {
        KlusDetailView(klus: KlusService.voorbeeldKlussen[0])
    }
}
