//
//  KlusDetailView.swift
//  Klusmaat
//
//  Feature Klussen: alles over één klus, met de knoppen om te helpen of een bericht te sturen. Gelijk aan
//  JobDetailScreen op Android.
//

import SwiftUI

struct KlusDetailView: View {
    let klus: Klus

    @State private var helptMee = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                VStack(spacing: 16) {
                    if !klus.fotos.isEmpty {
                        FotoGalerij(fotos: klus.fotos)
                    }
                    samenvatting
                }

                sectie("Omschrijving") {
                    Text(klus.beschrijving)
                        .foregroundStyle(Color.klusTekst)
                }

                sectie("Geplaatst door") { eigenaarKaart }

                sectie("Locatie") { locatie }

                knoppen
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background(.white)
        .navigationTitle("Klus")
        .navigationBarTitleDisplayMode(.inline)
        .tint(.klusGroen)
    }

    private var samenvatting: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(klus.soort.rawValue)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color.klusGroen)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color.klusSalie, in: .capsule)

                Spacer()

                Label(klus.afstand, systemImage: "mappin")
                    .font(.footnote)
                    .foregroundStyle(Color.klusTekstZacht)
            }

            Text(klus.titel)
                .font(.title2.bold())
                .foregroundStyle(Color.klusTekst)

            Text("Geplaatst \(klus.geplaatst)")
                .font(.footnote)
                .foregroundStyle(Color.klusTekstZacht)

            Rectangle()
                .fill(Color.klusZand)
                .frame(height: 1)

            HStack {
                Text("€ \(klus.vergoeding)")
                    .font(.title3.bold())
                    .foregroundStyle(Color.klusTekst)
                Spacer()
                Text("\(klus.wanneer) · \(klus.duur.rawValue)")
                    .font(.subheadline)
                    .foregroundStyle(Color.klusTekstZacht)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.klusPapier, in: .rect(cornerRadius: 28))
        .overlay { RoundedRectangle(cornerRadius: 28).strokeBorder(Color.klusZand) }
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
                Text("Buurtbewoner · \(klus.afstand) bij jou vandaan")
                    .font(.subheadline)
                    .foregroundStyle(Color.klusTekstZacht)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color.klusPapier, in: .rect(cornerRadius: 24))
        .overlay { RoundedRectangle(cornerRadius: 24).strokeBorder(Color.klusZand) }
    }

    private var locatie: some View {
        HStack(spacing: 14) {
            Image(systemName: "mappin")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.klusGroen)
                .frame(width: 40, height: 40)
                .background(Color.klusSalie, in: .circle)

            VStack(alignment: .leading, spacing: 2) {
                Text("Op \(klus.afstand) van jou")
                    .font(.body.weight(.medium))
                    .foregroundStyle(Color.klusTekst)
                Text(helptMee
                     ? "Het adres wordt met je gedeeld in de chat."
                     : "Het exacte adres zie je zodra je aanbiedt te helpen.")
                    .font(.subheadline)
                    .foregroundStyle(Color.klusTekstZacht)
                    .contentTransition(.opacity)
            }
        }
    }

    private var knoppen: some View {
        VStack(spacing: 12) {
            Button {
                withAnimation(.snappy) { helptMee.toggle() }
            } label: {
                Label(helptMee ? "Je helpt mee" : "Ik help mee",
                      systemImage: helptMee ? "checkmark" : "hands.clap")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.glassProminent)
            .tint(helptMee ? .klusSalie : .klusGroenDonker)
            .foregroundStyle(helptMee ? Color.klusGroen : .white)
            .accessibilityHint(helptMee ? "Trekt je aanbod in" : "Biedt aan om te helpen")

            // Reacties bestaat nog niet, dus deze knop doet nog niets
            Button {} label: {
                Label("Stuur \(klus.eigenaar) een bericht", systemImage: "bubble.left.and.bubble.right")
                    .font(.headline)
                    .foregroundStyle(Color.klusTekst)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.glass)
        }
    }

    private func sectie(_ titel: String, @ViewBuilder inhoud: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(titel)
                .font(.footnote.weight(.semibold))
                .textCase(.uppercase)
                .foregroundStyle(Color.klusTekstZacht)
            inhoud()
        }
    }
}

/// Foto's om doorheen te swipen, met teller en bolletjes als er meer dan één is.
private struct FotoGalerij: View {
    let fotos: [URL]

    @State private var huidige = 0

    var body: some View {
        TabView(selection: $huidige) {
            ForEach(fotos.indices, id: \.self) { index in
                AsyncImage(url: fotos[index]) { fase in
                    if let afbeelding = fase.image {
                        afbeelding.resizable().scaledToFill()
                    } else {
                        Color.klusSalie.overlay {
                            Image(systemName: fase.error == nil ? "photo" : "photo.badge.exclamationmark")
                                .font(.largeTitle)
                                .foregroundStyle(Color.klusGroen.opacity(0.5))
                        }
                    }
                }
                .accessibilityLabel("Foto \(index + 1) van \(fotos.count)")
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: fotos.count > 1 ? .always : .never))
        .overlay(alignment: .topTrailing) {
            if fotos.count > 1 {
                Text("\(huidige + 1)/\(fotos.count)")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.black.opacity(0.35), in: .capsule)
                    .padding(14)
            }
        }
        .frame(height: 240)
        .clipShape(.rect(cornerRadius: 28))
    }
}

#Preview {
    NavigationStack {
        KlusDetailView(klus: KlusService.voorbeeldKlussen[0])
    }
}
