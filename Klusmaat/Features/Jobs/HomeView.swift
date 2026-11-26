import SwiftUI

struct HomeView: View {
    @State private var search = JobSearch(jobs: JobActivity.shared.jobs)
    @State private var isShowingFilters = false
    @FocusState private var isSearchFocused: Bool
    @AppStorage("home.introDismissed") private var hasSeenIntro = false
    private let activity = JobActivity.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    locationMenu
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    if !hasSeenIntro {
                        intro
                            .padding(.horizontal, 20)
                            .padding(.bottom, 12)
                    }
                    CategoryBar(selected: $search.filters.category)
                    resultsHeader
                    if search.results.isEmpty {
                        ContentUnavailableView {
                            Label("Geen klussen gevonden", systemImage: "magnifyingglass")
                        } description: {
                            Text("Probeer een andere zoekterm of pas je filters aan.")
                        } actions: {
                            Button("Wis zoekopdracht") {
                                search.query = ""
                                search.filters = JobFilters()
                            }
                            .tint(.brandGreen)
                        }
                    } else {
                        LazyVStack(spacing: 0) {
                            ForEach(search.results) { job in
                                NavigationLink {
                                    JobDetailView(job: job)
                                } label: {
                                    JobRow(job: job)
                                }
                                .buttonStyle(.plain)
                                Divider().overlay(Color.linen)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 20)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .background(Color.paper)
            .navigationTitle("Klussen")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top, spacing: 0) {
                searchBar
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink { ProfileView() } label: { Image(systemName: "person") }
                        .accessibilityLabel("Profiel")
                }
            }
            .sheet(isPresented: $isShowingFilters) {
                FiltersView(filters: $search.filters, jobs: activity.jobs)
                    .presentationDragIndicator(.visible)
            }
            .tint(.textPrimary)
            .onChange(of: activity.posted.map(\.id)) { search.setJobs(activity.jobs) }
        }
    }

    private var intro: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "hand.raised.fill")
                .font(.title3)
                .foregroundStyle(Color.brandGreen)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text("Help je buren en verdien wat bij")
                    .font(.subheadline.weight(.semibold))
                Text("Kies een klus, tik op ‘Ik wil helpen’ en ontvang de vergoeding als je de klus hebt gedaan. Helpen kost je niets.")
                    .font(.footnote)
                    .foregroundStyle(Color.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
            Button {
                withAnimation(.snappy) { hasSeenIntro = true }
            } label: {
                Image(systemName: "xmark")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(Color.textSecondary)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Uitleg sluiten")
        }
        .foregroundStyle(Color.textPrimary)
        .padding(14)
        .background(Color.sage.opacity(0.3), in: .rect(cornerRadius: 16))
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.textSecondary)
                .accessibilityHidden(true)

            TextField("Zoek een klus", text: $search.query)
                .focused($isSearchFocused)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .onSubmit { isSearchFocused = false }
                .accessibilityLabel("Zoek een klus")

            if !search.query.isEmpty {
                Button {
                    search.query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.textSecondary)
                        .frame(minWidth: 44, minHeight: 44)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Zoekterm wissen")
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, search.query.isEmpty ? 16 : 4)
        .frame(minHeight: 48)
        .glassEffect(.regular, in: .capsule)
    }

    private var locationMenu: some View {
        Menu {
            Picker("Afstand", selection: $search.filters.radiusKm) {
                ForEach(JobFilters.radii, id: \.self) { km in
                    Text(km.map { "\($0) km" } ?? "Overal").tag(km)
                }
            }
            Button("Locatie wijzigen", systemImage: "mappin.and.ellipse") { isShowingFilters = true }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "mappin.and.ellipse").foregroundStyle(Color.brandGreen)
                Text(search.filters.locationLabel)
                Image(systemName: "chevron.down").font(.caption2)
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Color.textPrimary)
            .frame(minHeight: 32)
        }
    }

    private var resultsHeader: some View {
        HStack(spacing: 18) {
            Text(search.results.count == 1 ? "1 klus" : "\(search.results.count) klussen")
                .fontWeight(.semibold)
            Spacer(minLength: 0)
            Menu {
                Picker("Sorteren", selection: $search.sortOrder) {
                    ForEach(JobSortOrder.allCases) { order in Text(order.rawValue).tag(order) }
                }
            } label: {
                HStack(spacing: 4) {
                    Text(search.sortOrder.rawValue)
                    Image(systemName: "chevron.down").font(.caption2)
                }
            }
            Button { isShowingFilters = true } label: {
                Label(search.filters.refinementCount > 0 ? "Filters (\(search.filters.refinementCount))" : "Filters",
                      systemImage: "slider.horizontal.3")
            }
            .accessibilityLabel("Filters")
        }
        .font(.subheadline)
        .foregroundStyle(Color.textPrimary)
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

#Preview { HomeView() }
