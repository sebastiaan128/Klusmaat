import SwiftUI

struct HomeView: View {
    var onProfiel: () -> Void = {}
    var onPlaatsen: () -> Void = {}

    @State private var filters = KlusFilters()
    @State private var toontResultaten = false

    private let klussen = KlusService.voorbeeldKlussen

    var body: some View {
        NavigationStack {
            zoekScherm
                .toolbarVisibility(.hidden, for: .navigationBar)
                .navigationDestination(isPresented: $toontResultaten) {
                    ResultatenView(filters: $filters, klussen: klussen)
                }
        }
    }

    private var aantalGevonden: Int {
        klussen.passend(bij: filters).count
    }

    private var zoekScherm: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                kop
                filterKaart
                toonKnop
                hulpKaart
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
        .background(.white)
        .task {
            // Postcode alvast invullen, behalve als de gebruiker zelf al iets heeft getypt
            guard filters.postcode.isEmpty, let postcode = await LocatieService.huidigePostcode(),
                  filters.postcode.isEmpty else { return }
            filters.postcode = postcode
        }
    }

    private var kop: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Klussen")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(Color.klusTekst)
                Text("\(klussenLabel(klussen.count, soort: nil)) in de buurt")
                    .font(.callout)
                    .foregroundStyle(Color.klusTekstZacht)
            }

            Spacer()

            Button(action: onProfiel) {
                Image(systemName: "person")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Color.klusGroen)
                    .frame(width: 56, height: 56)
            }
            .buttonStyle(.plain)
            .glassEffect(.regular.interactive(), in: .circle)
            .accessibilityLabel("Profiel")
        }
    }

    private var filterKaart: some View {
        VStack(spacing: 0) {
            FilterRij(icoon: "pencil", titel: "Soort klus") {
                Picker("Soort klus", selection: $filters.soort) {
                    Text("Alle soorten").tag(KlusSoort?.none)
                    ForEach(KlusSoort.allCases) { soort in
                        Text(soort.rawValue).tag(Optional(soort))
                    }
                }
            }

            scheiding

            FilterRij(icoon: "mappin", titel: "Locatie") {
                TextField("bv. 3512 AB", text: $filters.postcode)
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(Color.klusTekstZacht)
                    .frame(maxWidth: 120)
                    .textContentType(.postalCode)
            }

            scheiding

            FilterRij(icoon: "scope", titel: "Afstand") {
                Picker("Afstand", selection: $filters.straalKm) {
                    ForEach(KlusFilters.stralen, id: \.self) { km in
                        Text(km.map { "+ \($0) km" } ?? "Overal").tag(km)
                    }
                }
            }

            scheiding

            FilterRij(icoon: "eurosign", titel: "Vergoeding") {
                Picker("Vergoeding vanaf", selection: $filters.minVergoeding) {
                    Text("Geen min.").tag(Int?.none)
                    ForEach(KlusFilters.minimaleVergoedingen, id: \.self) { bedrag in
                        Text("€ \(bedrag)").tag(Optional(bedrag))
                    }
                }
            }
        }
        // Alleen de waarde rechts opent het menu, zodat de rij zelf blijft staan
        .pickerStyle(.menu)
        .tint(Color.klusTekstZacht)
        .background(Color.klusPapier, in: .rect(cornerRadius: 24))
        .overlay { RoundedRectangle(cornerRadius: 24).strokeBorder(Color.klusZand) }
    }

    private var scheiding: some View {
        Rectangle()
            .fill(Color.klusZand)
            .frame(height: 1)
            .padding(.leading, 64)
    }

    private var toonKnop: some View {
        Button {
            toontResultaten = true
        } label: {
            Label(
                aantalGevonden == 0 ? "Geen klussen gevonden" : "Toon \(klussenLabel(aantalGevonden, soort: filters.soort))",
                systemImage: "magnifyingglass"
            )
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        }
        .buttonStyle(.glassProminent)
        .tint(.klusGroenDonker)
        .disabled(aantalGevonden == 0)
    }

    private var hulpKaart: some View {
        Button(action: onPlaatsen) {
            HStack(spacing: 16) {
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Color.klusGroen)
                    .frame(width: 52, height: 52)
                    .background(Color.klusSalie, in: .rect(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Zelf hulp nodig?")
                        .font(.headline)
                        .foregroundStyle(Color.klusTekst)
                    Text("Plaats je klus in een minuut")
                        .font(.subheadline)
                        .foregroundStyle(Color.klusTekstZacht)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color.klusTekstZacht)
            }
            .padding(16)
            .background(Color.klusPapier, in: .rect(cornerRadius: 24))
            .overlay { RoundedRectangle(cornerRadius: 24).strokeBorder(Color.klusZand) }
        }
        .buttonStyle(.plain)
    }
}

/// Eén regel in de filterkaart: icoon, titel en rechts de waarde.
private struct FilterRij<Waarde: View>: View {
    let icoon: String
    let titel: String
    @ViewBuilder let waardeView: Waarde

    init(icoon: String, titel: String, @ViewBuilder waarde: () -> Waarde) {
        self.icoon = icoon
        self.titel = titel
        self.waardeView = waarde()
    }

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icoon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.klusGroen)
                .frame(width: 32, height: 32)
                .background(Color.klusSalie, in: .rect(cornerRadius: 9))

            Text(titel)
                .foregroundStyle(Color.klusTekst)
                .lineLimit(1)

            Spacer(minLength: 8)

            waardeView
                .fixedSize()
        }
        .padding(.horizontal, 16)
        .frame(height: 64)
        .contentShape(.rect)
    }
}

#Preview {
    HomeView()
}
