import SwiftUI

struct ResultsView: View {
    @Binding var filters: JobFilters
    let jobs: [Job]

    @State private var sortOrder = JobSortOrder.newest
    @State private var isShowingFilters = false

    private var results: [Job] {
        sortOrder.sort(jobs.matching(filters))
    }

    var body: some View {
        let results = results
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                activeFilters

                if results.isEmpty {
                    emptyState
                } else {
                    Text("\(results.count) resultaten")
                        .font(.footnote.weight(.semibold))
                        .textCase(.uppercase)
                        .foregroundStyle(Color.textSecondary)
                        .padding(.horizontal, 20)

                    LazyVStack(spacing: 12) {
                        ForEach(results) { job in
                            NavigationLink {
                                JobDetailView(job: job)
                            } label: {
                                JobCard(job: job)
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
        .navigationTitle(filters.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    isShowingFilters = true
                } label: {
                    VStack(spacing: 0) {
                        Text(filters.title)
                            .font(.headline)
                        Text(filters.locationLabel)
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                    }
                    .foregroundStyle(Color.textPrimary)
                }
                .buttonStyle(.plain)
                .accessibilityHint("Zoekopdracht wijzigen")
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Menu {
                    Picker("Sorteren", selection: $sortOrder) {
                        ForEach(JobSortOrder.allCases) { sortOrder in
                            Text(sortOrder.rawValue).tag(sortOrder)
                        }
                    }
                } label: {
                    Label("Sorteren", systemImage: "arrow.up.arrow.down")
                }

                Button {
                    isShowingFilters = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .overlay(alignment: .topTrailing) { filterBadge }
                }
                .accessibilityLabel("Filters")
                .accessibilityValue(filters.refinementCount == 0 ? "" : "\(filters.refinementCount) actief")
            }
        }
        .tint(.brandGreen)
        .sheet(isPresented: $isShowingFilters) {
            FiltersView(filters: $filters, jobs: jobs)
        }
    }


    @ViewBuilder
    private var filterBadge: some View {
        let count = filters.refinementCount
        if count > 0 {
            Text("\(count)")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white)
                .frame(minWidth: 17, minHeight: 17)
                .background(Color.brandGreen, in: .circle)
                .offset(x: 9, y: -9)
        }
    }


    @ViewBuilder
    private var activeFilters: some View {
        let chips = filterChips
        if !chips.isEmpty {
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(chips, id: \.label) { chip in
                        Button {
                            withAnimation(.snappy) { filters = chip.without }
                        } label: {
                            HStack(spacing: 6) {
                                Text(chip.label)
                                Image(systemName: "xmark")
                                    .font(.caption.weight(.bold))
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.paper)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            .background(Color.brandGreen, in: .capsule)
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

    private var filterChips: [(label: String, without: JobFilters)] {
        var chips: [(label: String, without: JobFilters)] = []
        func add(_ label: String, _ change: (inout JobFilters) -> Void) {
            var without = filters
            change(&without)
            chips.append((label, without))
        }

        if let min = filters.minPay { add("Vanaf € \(min)") { $0.minPay = nil } }
        if let max = filters.maxPay { add("Tot € \(max)") { $0.maxPay = nil } }
        if let timing = filters.timing { add(timing.rawValue) { $0.timing = nil } }
        for duration in JobDuration.allCases where filters.durations.contains(duration) {
            add(duration.rawValue) { $0.durations.remove(duration) }
        }
        if filters.toolsProvided { add("Gereedschap aanwezig") { $0.toolsProvided = false } }
        if filters.wasteRemoved { add("Afval wordt afgevoerd") { $0.wasteRemoved = false } }
        if filters.onlyNew { add("Alleen nieuwe klussen") { $0.onlyNew = false } }
        return chips
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("Geen klussen gevonden", systemImage: "magnifyingglass")
        } description: {
            Text("Er zijn geen klussen die bij al je filters passen. Haal een filter weg of vergroot de afstand.")
        } actions: {
            Button("Alles wissen") {
                withAnimation(.snappy) { filters = filters.withoutRefinements() }
            }
            .buttonStyle(.glassProminent)
            .tint(.brandGreenDark)
        }
        .foregroundStyle(Color.textPrimary)
        .padding(.top, 40)
    }
}

private struct JobCard: View {
    let job: Job

    var body: some View {
        HStack(spacing: 14) {
            photo

            VStack(alignment: .leading, spacing: 4) {
                Text(job.title)
                    .font(.headline)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text("\(job.distance) · \(job.dateLabel)")
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("€ \(job.pay)")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.brandGreen)
                    Text(job.duration.rawValue)
                        .font(.subheadline)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.top, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color.textSecondary)
        }
        .padding(12)
        .background(Color.paper, in: .rect(cornerRadius: 20))
        .overlay { RoundedRectangle(cornerRadius: 20).strokeBorder(Color.sand) }
        .contentShape(.rect(cornerRadius: 20))
    }

    private var photo: some View {
        ZStack(alignment: .topLeading) {
            Color.sage
                .overlay {
                    Image(systemName: job.category.icon)
                        .font(.title2)
                        .foregroundStyle(Color.brandGreen)
                }
                .overlay {
                    if let url = job.photos.first {
                        JobImage(url: url, maxPoints: 84) {
                            Color.clear
                        }
                    }
                }
                .clipShape(.rect(cornerRadius: 14))

            if job.isNew {
                Text("Nieuw")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(Color.brandGreen)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.sage, in: .capsule)
                    .padding(6)
            }
        }
        .frame(width: 84, height: 84)
    }
}

#Preview {
    @Previewable @State var filters = JobFilters(category: .garden, timing: .weekend)
    NavigationStack {
        ResultsView(filters: $filters, jobs: JobService.sampleJobs)
    }
}
