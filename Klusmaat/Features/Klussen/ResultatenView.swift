//
//  ResultatenView.swift
//  Klusmaat
//
//  Feature Klussen: de klussen die passen bij de zoekopdracht van het startscherm, met sortering en filtersheet.
//

import SwiftUI

struct ResultatenView: View {
    @Binding var filters: KlusFilters
    let klussen: [Klus]

    @State private var sortering = KlusSortering.nieuwste
    @State private var toontFilters = false

    private var resultaten: [Klus] {
        sortering.sorteer(klussen.passend(bij: filters))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                actieveFilters

                if resultaten.isEmpty {
                    geenResultaten
                } else {
                    Text("\(resultaten.count) resultaten")
                        .font(.footnote.weight(.semibold))
                        .textCase(.uppercase)
                        .foregroundStyle(Color.klusTekstZacht)
                        .padding(.horizontal, 20)

                    LazyVStack(spacing: 12) {
                        ForEach(resultaten) { klus in
                            NavigationLink {
                                KlusDetailView(klus: klus)
                            } label: {
                                KlusKaart(klus: klus)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .background(.white)
        .navigationTitle(filters.titel)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 0) {
                    Text(filters.titel)
                        .font(.headline)
                    Text(filters.locatieLabel)
                        .font(.caption)
                        .foregroundStyle(Color.klusTekstZacht)
                }
                .foregroundStyle(Color.klusTekst)
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Menu {
                    Picker("Sorteren", selection: $sortering) {
                        ForEach(KlusSortering.allCases) { sortering in
                            Text(sortering.rawValue).tag(sortering)
                        }
                    }
                } label: {
                    Label("Sorteren", systemImage: "arrow.up.arrow.down")
                }

                Button {
                    toontFilters = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .overlay(alignment: .topTrailing) { filterBolletje }
                }
                .accessibilityLabel("Filters")
                .accessibilityValue(filters.aantalVerfijningen == 0 ? "" : "\(filters.aantalVerfijningen) actief")
            }
        }
        .tint(.klusGroen)
        .sheet(isPresented: $toontFilters) {
            FiltersView(filters: $filters, klussen: klussen)
        }
    }

    /// Groen bolletje met het aantal filters uit de sheet, in plaats van het rode standaardbolletje.
    @ViewBuilder
    private var filterBolletje: some View {
        let aantal = filters.aantalVerfijningen
        if aantal > 0 {
            Text("\(aantal)")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white)
                .frame(minWidth: 17, minHeight: 17)
                .background(Color.klusGroen, in: .circle)
                .offset(x: 9, y: -9)
        }
    }

    /// Filters uit de sheet als chips; een tik haalt het filter weg, net als ActiveFilterChips op Android.
    @ViewBuilder
    private var actieveFilters: some View {
        let chips = filterChips
        if !chips.isEmpty {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(chips, id: \.label) { chip in
                        Button {
                            withAnimation(.snappy) { filters = chip.zonder }
                        } label: {
                            HStack(spacing: 6) {
                                Text(chip.label)
                                Image(systemName: "xmark")
                                    .font(.caption.weight(.bold))
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.klusPapier)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            .background(Color.klusGroen, in: .capsule)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Filter \(chip.label) verwijderen")
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.hidden)
        }
    }

    private var filterChips: [(label: String, zonder: KlusFilters)] {
        var chips: [(label: String, zonder: KlusFilters)] = []
        func voegToe(_ label: String, _ aanpassing: (inout KlusFilters) -> Void) {
            var zonder = filters
            aanpassing(&zonder)
            chips.append((label, zonder))
        }

        if let min = filters.minVergoeding { voegToe("Vanaf € \(min)") { $0.minVergoeding = nil } }
        if let max = filters.maxVergoeding { voegToe("Tot € \(max)") { $0.maxVergoeding = nil } }
        if let timing = filters.timing { voegToe(timing.rawValue) { $0.timing = nil } }
        for duur in KlusDuur.allCases where filters.duren.contains(duur) {
            voegToe(duur.rawValue) { $0.duren.remove(duur) }
        }
        if filters.gereedschapAanwezig { voegToe("Gereedschap aanwezig") { $0.gereedschapAanwezig = false } }
        if filters.afvalWordtAfgevoerd { voegToe("Afval wordt afgevoerd") { $0.afvalWordtAfgevoerd = false } }
        return chips
    }

    private var geenResultaten: some View {
        ContentUnavailableView {
            Label("Geen klussen gevonden", systemImage: "magnifyingglass")
        } description: {
            Text("Er zijn geen klussen die bij al je filters passen. Haal een filter weg of vergroot de afstand.")
        } actions: {
            Button("Filters wissen") {
                withAnimation(.snappy) { filters = filters.zonderVerfijningen() }
            }
            .buttonStyle(.glassProminent)
            .tint(.klusGroenDonker)
        }
        .foregroundStyle(Color.klusTekst)
        .padding(.top, 40)
    }
}

/// Klus in de resultatenlijst: foto, titel, vergoeding, afstand en wanneer.
private struct KlusKaart: View {
    let klus: Klus

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            foto

            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(klus.titel)
                        .font(.headline)
                        .foregroundStyle(Color.klusTekst)
                        .lineLimit(2)
                    Spacer(minLength: 8)
                    Text("€ \(klus.vergoeding)")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.klusTekst)
                }
                Text(klus.afstand)
                Text("\(klus.wanneer) · \(klus.duur.rawValue)")
            }
            .font(.subheadline)
            .foregroundStyle(Color.klusTekstZacht)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color.klusTekstZacht)
                .frame(maxHeight: .infinity)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.klusPapier, in: .rect(cornerRadius: 20))
        .overlay { RoundedRectangle(cornerRadius: 20).strokeBorder(Color.klusZand) }
        .contentShape(.rect(cornerRadius: 20))
    }

    private var foto: some View {
        ZStack(alignment: .topLeading) {
            Color.klusSalie
                .overlay {
                    Image(systemName: klus.soort.icoon)
                        .font(.title2)
                        .foregroundStyle(Color.klusGroen)
                }
                .overlay {
                    if let url = klus.fotos.first {
                        AsyncImage(url: url) { afbeelding in
                            afbeelding.resizable().scaledToFill()
                        } placeholder: {
                            Color.clear
                        }
                    }
                }
                .clipShape(.rect(cornerRadius: 14))

            if klus.isNieuw {
                Text("Nieuw")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Color.klusGroen)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.klusSalie, in: .capsule)
                    .padding(6)
            }
        }
        .frame(width: 96, height: 96)
    }
}

#Preview {
    @Previewable @State var filters = KlusFilters(soort: .tuin, timing: .weekend)
    NavigationStack {
        ResultatenView(filters: $filters, klussen: KlusService.voorbeeldKlussen)
    }
}
