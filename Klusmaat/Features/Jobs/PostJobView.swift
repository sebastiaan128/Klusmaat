import SwiftUI

struct PostJobView: View {
    var onPosted: () -> Void = {}

    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var category: JobCategory?
    @State private var summary = ""
    @State private var description = ""
    @State private var pay: Int?
    @State private var hasFixedDate = true
    @State private var date = Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now
    @State private var duration = JobDuration.short
    @State private var toolsProvided = false
    @State private var wasteRemoved = false
    @State private var isSubmitted = false
    @State private var isShowingDiscard = false
    @State private var isShowingSuccess = false

    static let summaryLimit = 80

    private var trimmedTitle: String { title.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var trimmedDescription: String { description.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var trimmedSummary: String { summary.trimmingCharacters(in: .whitespacesAndNewlines) }

    private var titleError: String? { trimmedTitle.isEmpty ? "Vul een titel in." : nil }
    private var categoryError: String? { category == nil ? "Kies een soort klus." : nil }
    private var summaryError: String? { trimmedSummary.isEmpty ? "Vat je klus samen in één zin." : nil }
    private var descriptionError: String? { trimmedDescription.isEmpty ? "Beschrijf je klus." : nil }
    private var payError: String? { (pay ?? 0) > 0 ? nil : "Vul een vergoeding in." }

    private var isValid: Bool {
        [titleError, categoryError, summaryError, descriptionError, payError].allSatisfy { $0 == nil }
    }

    private var hasChanges: Bool {
        !trimmedTitle.isEmpty || category != nil || !trimmedSummary.isEmpty || !trimmedDescription.isEmpty || pay != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("bv. Heg snoeien in de achtertuin", text: $title)
                        .textInputAutocapitalization(.sentences)
                    Picker("Soort klus", selection: $category) {
                        Text("Kies…").tag(JobCategory?.none)
                        ForEach(JobCategory.allCases) { category in
                            Label(category.rawValue, systemImage: category.icon).tag(Optional(category))
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    header("Wat moet er gebeuren?")
                } footer: {
                    footer(errors: [titleError, categoryError], hint: "Kort en duidelijk, dit zien mensen als eerste.")
                }
                .listRowBackground(Color.paper)

                Section {
                    TextField("bv. 6 meter heg bijknippen, gereedschap ligt klaar", text: $summary, axis: .vertical)
                        .lineLimit(1...2)
                        .onChange(of: summary) {
                            if summary.count > Self.summaryLimit { summary = String(summary.prefix(Self.summaryLimit)) }
                        }
                } header: {
                    header("In het kort")
                } footer: {
                    footer(errors: [summaryError],
                           hint: "Eén zin die helpers als eerste lezen. \(summary.count)/\(Self.summaryLimit)")
                }
                .listRowBackground(Color.paper)

                Section {
                    TextField("Wat moet er precies gebeuren? Hoe groot is de klus?",
                              text: $description, axis: .vertical)
                        .lineLimit(4...10)
                } header: {
                    header("Vertel er meer over")
                } footer: {
                    footer(errors: [descriptionError], hint: "Hoe meer details, hoe sneller iemand kan helpen.")
                }
                .listRowBackground(Color.paper)

                Section {
                    Picker("Wanneer", selection: $hasFixedDate.animation(.snappy)) {
                        Text("Op een vaste dag").tag(true)
                        Text("Datum flexibel").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    if hasFixedDate {
                        DatePicker("Datum", selection: $date, in: Calendar.current.startOfDay(for: .now)...,
                                   displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .environment(\.locale, Locale(identifier: "nl_NL"))
                    }
                    Picker("Duur", selection: $duration) {
                        ForEach(JobDuration.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.menu)
                } header: {
                    header("Wanneer en hoe lang")
                } footer: {
                    if !hasFixedDate {
                        Text("Je spreekt de dag samen met de helper af.").foregroundStyle(Color.textSecondary)
                    }
                }
                .listRowBackground(Color.paper)

                Section {
                    LabeledContent("Bedrag") {
                        TextField("€ 0", value: $pay, format: .currency(code: "EUR").precision(.fractionLength(0)))
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                } header: {
                    header("Vergoeding")
                } footer: {
                    footer(errors: [payError], hint: "Wat je de helper betaalt voor de hele klus.")
                }
                .listRowBackground(Color.paper)

                Section {
                    Toggle("Gereedschap aanwezig", isOn: $toolsProvided)
                    Toggle("Afval wordt afgevoerd", isOn: $wasteRemoved)
                } header: {
                    header("Extra")
                } footer: {
                    Text(toolsProvided ? "Helpers zien dat het gereedschap klaarligt."
                                       : "Helpers zien dat ze zelf gereedschap moeten meenemen.")
                        .foregroundStyle(Color.textSecondary)
                }
                .listRowBackground(Color.paper)
            }
            .foregroundStyle(Color.textPrimary)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .background(Color.cream)
            .navigationTitle("Klus plaatsen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleren", systemImage: "xmark") {
                        if hasChanges { isShowingDiscard = true } else { dismiss() }
                    }
                    .labelStyle(.iconOnly)
                }
            }
            .confirmationDialog("Klus niet plaatsen?", isPresented: $isShowingDiscard, titleVisibility: .visible) {
                Button("Verwijder concept", role: .destructive) { dismiss() }
                Button("Verder bewerken", role: .cancel) {}
            } message: {
                Text("Wat je hebt ingevuld gaat verloren.")
            }
            .alert("Je klus is geplaatst", isPresented: $isShowingSuccess) {
                Button("Bekijk mijn klussen") {
                    dismiss()
                    onPosted()
                }
            } message: {
                Text("‘\(trimmedTitle)’ staat online. Buren in de buurt kunnen nu hulp aanbieden.")
            }
            .safeAreaInset(edge: .bottom) {
                Button(action: submit) {
                    Label("Plaats klus", systemImage: "plus")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.glassProminent)
                .tint(.accentOrange)
                .disabled(isShowingSuccess)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
        }
        .tint(.brandGreen)
        .interactiveDismissDisabled(hasChanges)
    }

    private func header(_ title: String) -> some View {
        Text(title)
            .font(.footnote.weight(.semibold))
            .textCase(.uppercase)
            .foregroundStyle(Color.textSecondary)
    }

    @ViewBuilder
    private func footer(errors: [String?], hint: String) -> some View {
        let shown = isSubmitted ? errors.compactMap { $0 } : []
        if shown.isEmpty {
            Text(hint).foregroundStyle(Color.textSecondary)
        } else {
            Text(shown.joined(separator: " ")).foregroundStyle(.red)
        }
    }

    private func submit() {
        isSubmitted = true
        guard isValid, let category, let pay else { return }
        let chosenDate = hasFixedDate ? date : nil
        JobActivity.shared.post(PostedJob(
            title: trimmedTitle, category: category, description: trimmedDescription,
            summary: trimmedSummary, date: chosenDate, pay: pay,
            timing: PostedJob.timing(for: chosenDate), duration: duration,
            toolsProvided: toolsProvided, wasteRemoved: wasteRemoved
        ))
        isShowingSuccess = true
    }
}

#Preview {
    PostJobView()
}
