import SwiftUI

struct FiltersView: View {
    @Binding var filters: JobFilters
    let jobs: [Job]

    @Environment(\.dismiss) private var dismiss
    @State private var draft: JobFilters

    init(filters: Binding<JobFilters>, jobs: [Job]) {
        _filters = filters
        self.jobs = jobs
        _draft = State(initialValue: filters.wrappedValue)
    }

    private var matchCount: Int {
        jobs.matching(draft).count
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Soort klus", selection: $draft.category) {
                        Text("Alle soorten").tag(JobCategory?.none)
                        ForEach(JobCategory.allCases) { category in
                            Text(category.rawValue).tag(Optional(category))
                        }
                    }
                    LabeledContent("Postcode") {
                        TextField("bv. 3512 AB", text: $draft.postalCode)
                            .multilineTextAlignment(.trailing)
                            .textContentType(.postalCode)
                    }
                    Picker("Afstand", selection: $draft.radiusKm) {
                        ForEach(JobFilters.radii, id: \.self) { km in
                            Text(km.map { "\($0) km" } ?? "Overal").tag(km)
                        }
                    }
                } header: {
                    header("Zoekopdracht")
                }
                .pickerStyle(.menu)
                .listRowBackground(Color.paper)

                Section {
                    ForEach(JobDuration.allCases) { duration in
                        durationRow(duration)
                    }
                } header: {
                    header("Duur")
                }
                .listRowBackground(Color.paper)

                Section {
                    Picker("Wanneer", selection: $draft.timing) {
                        Text("Maakt niet uit").tag(JobTiming?.none)
                        Text(JobTiming.thisWeek.rawValue).tag(Optional(JobTiming.thisWeek))
                        Text(JobTiming.weekend.rawValue).tag(Optional(JobTiming.weekend))
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                } header: {
                    header("Wanneer")
                }

                Section {
                    amountRow("Van", amount: $draft.minPay, placeholder: "€ 0")
                    amountRow("Tot", amount: $draft.maxPay, placeholder: "€ max")
                } header: {
                    header("Vergoeding")
                }
                .listRowBackground(Color.paper)

                Section {
                    Toggle("Gereedschap aanwezig", isOn: $draft.toolsProvided)
                    Toggle("Afval wordt afgevoerd", isOn: $draft.wasteRemoved)
                    Toggle("Alleen nieuwe klussen", isOn: $draft.onlyNew)
                } header: {
                    header("Extra")
                }
                .listRowBackground(Color.paper)
            }
            .foregroundStyle(Color.textPrimary)
            .scrollContentBackground(.hidden)
            .background(Color.cream)
            .navigationTitle("Filters")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Sluiten", systemImage: "xmark") { dismiss() }
                        .labelStyle(.iconOnly)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Alles wissen") { draft = JobFilters() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button(action: apply) {
                    Text(matchCount == 0 ? "Geen klussen met deze filters" : "Toon \(matchCount) \(matchCount == 1 ? "klus" : "klussen")")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.glassProminent)
                .tint(.brandGreenDark)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
        }
        .tint(.brandGreen)
    }

    private func header(_ title: String) -> some View {
        Text(title)
            .font(.footnote.weight(.semibold))
            .textCase(.uppercase)
            .foregroundStyle(Color.textSecondary)
    }

    private func durationRow(_ duration: JobDuration) -> some View {
        let isSelected = draft.durations.contains(duration)

        return Button {
            if isSelected {
                draft.durations.remove(duration)
            } else {
                draft.durations.insert(duration)
            }
        } label: {
            HStack {
                Text(duration.rawValue)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.brandGreen)
                }
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func amountRow(_ title: String, amount: Binding<Int?>, placeholder: String) -> some View {
        LabeledContent(title) {
            TextField(placeholder, value: amount, format: .currency(code: "EUR").precision(.fractionLength(0)))
                .multilineTextAlignment(.trailing)
                #if os(iOS)
                .keyboardType(.numberPad)
                #endif
        }
    }

    private func apply() {
        filters = draft
        dismiss()
    }
}

#Preview {
    @Previewable @State var filters = JobFilters(category: .garden, durations: [.halfDay], toolsProvided: true)
    Color.clear
        .sheet(isPresented: .constant(true)) {
            FiltersView(filters: $filters, jobs: JobService.sampleJobs)
        }
}
