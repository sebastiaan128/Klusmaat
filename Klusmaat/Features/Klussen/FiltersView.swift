//
//  FiltersView.swift
//  Klusmaat
//
//  Feature Klussen: sheet om de zoekopdracht en de zoekresultaten te filteren. Wijzigingen gelden pas na het vinkje of de knop onderaan.
//

import SwiftUI

struct FiltersView: View {
    @Binding var filters: KlusFilters
    let klussen: [Klus]

    @Environment(\.dismiss) private var dismiss
    @State private var concept: KlusFilters

    init(filters: Binding<KlusFilters>, klussen: [Klus]) {
        _filters = filters
        self.klussen = klussen
        _concept = State(initialValue: filters.wrappedValue)
    }

    private var aantalGevonden: Int {
        klussen.passend(bij: concept).count
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Soort klus", selection: $concept.soort) {
                        Text("Alle soorten").tag(KlusSoort?.none)
                        ForEach(KlusSoort.allCases) { soort in
                            Text(soort.rawValue).tag(Optional(soort))
                        }
                    }
                    LabeledContent("Locatie") {
                        TextField("bv. 3512 AB", text: $concept.postcode)
                            .multilineTextAlignment(.trailing)
                            .textContentType(.postalCode)
                    }
                    Picker("Afstand", selection: $concept.straalKm) {
                        ForEach(KlusFilters.stralen, id: \.self) { km in
                            Text(km.map { "+ \($0) km" } ?? "Overal").tag(km)
                        }
                    }
                } header: {
                    kop("Zoekopdracht")
                }
                .pickerStyle(.menu)
                .listRowBackground(Color.klusPapier)

                Section {
                    ForEach(KlusDuur.allCases) { duur in
                        duurRij(duur)
                    }
                } header: {
                    kop("Duur")
                }
                .listRowBackground(Color.klusPapier)

                Section {
                    Picker("Wanneer", selection: $concept.timing) {
                        Text("Altijd").tag(KlusTiming?.none)
                        Text(KlusTiming.dezeWeek.rawValue).tag(Optional(KlusTiming.dezeWeek))
                        Text(KlusTiming.weekend.rawValue).tag(Optional(KlusTiming.weekend))
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                } header: {
                    kop("Wanneer")
                }

                Section {
                    bedragRij("Van", bedrag: $concept.minVergoeding, placeholder: "€ 0")
                    bedragRij("Tot", bedrag: $concept.maxVergoeding, placeholder: "Geen maximum")
                } header: {
                    kop("Vergoeding")
                }
                .listRowBackground(Color.klusPapier)

                Section {
                    Toggle("Gereedschap aanwezig", isOn: $concept.gereedschapAanwezig)
                    Toggle("Afval wordt afgevoerd", isOn: $concept.afvalWordtAfgevoerd)
                } header: {
                    kop("Extra")
                }
                .listRowBackground(Color.klusPapier)
            }
            .foregroundStyle(Color.klusTekst)
            .scrollContentBackground(.hidden)
            .background(.white)
            .navigationTitle("Filters")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(role: .confirm, action: toepassen)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button(action: toepassen) {
                    Text(aantalGevonden == 0 ? "Geen klussen met deze filters" : "Toon \(klussenLabel(aantalGevonden, soort: concept.soort))")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.glassProminent)
                .tint(.klusGroenDonker)
                .disabled(aantalGevonden == 0)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
        }
        .tint(.klusGroen)
    }

    private func kop(_ titel: String) -> some View {
        Text(titel)
            .font(.footnote.weight(.semibold))
            .textCase(.uppercase)
            .foregroundStyle(Color.klusTekstZacht)
    }

    private func duurRij(_ duur: KlusDuur) -> some View {
        let gekozen = concept.duren.contains(duur)

        return Button {
            if gekozen {
                concept.duren.remove(duur)
            } else {
                concept.duren.insert(duur)
            }
        } label: {
            HStack {
                Text(duur.rawValue)
                Spacer()
                if gekozen {
                    Image(systemName: "checkmark")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.klusGroen)
                }
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(gekozen ? .isSelected : [])
    }

    private func bedragRij(_ titel: String, bedrag: Binding<Int?>, placeholder: String) -> some View {
        LabeledContent(titel) {
            TextField(placeholder, value: bedrag, format: .currency(code: "EUR").precision(.fractionLength(0)))
                .multilineTextAlignment(.trailing)
                #if os(iOS)
                .keyboardType(.numberPad)
                #endif
        }
    }

    private func toepassen() {
        filters = concept
        dismiss()
    }
}

#Preview {
    @Previewable @State var filters = KlusFilters(soort: .tuin, duren: [.halveDag], gereedschapAanwezig: true)
    Color.clear
        .sheet(isPresented: .constant(true)) {
            FiltersView(filters: $filters, klussen: KlusService.voorbeeldKlussen)
        }
}
