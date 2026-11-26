import SwiftUI

struct JobDetailView: View {
    let job: Job

    private let activity = JobActivity.shared
    @State private var isShowingOffer = false
    @State private var isShowingWithdrawal = false
    @State private var isShowingOwner = false
    @State private var isDescriptionExpanded = false

    private var isHelping: Bool { activity.offeredIDs.contains(job.id) }
    private var isSaved: Bool { activity.savedIDs.contains(job.id) }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                PhotoGallery(job: job)
                    .frame(height: 350)
                content
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .background(Color.paper)
        .safeAreaInset(edge: .bottom) { actionBar }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        .toolbarVisibility(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    withAnimation(.snappy) { activity.toggleSaved(job) }
                    AppState.shared.show(isSaved ? "Klus bewaard" : "Klus niet meer bewaard",
                                         icon: isSaved ? "heart.fill" : "heart.slash",
                                         style: isSaved ? .success : .info)
                } label: {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .foregroundStyle(isSaved ? Color.brandGreen : Color.textPrimary)
                        .contentTransition(.symbolEffect(.replace))
                }
                .accessibilityLabel(isSaved ? "Niet meer bewaren" : "Bewaren")
                .accessibilityValue(isSaved ? "Bewaard" : "Niet bewaard")
                ShareLink(item: "\(job.title) — € \(job.pay)\n\(job.category.rawValue) · \(job.dateLabel)\n\n\(job.description)") {
                    Image(systemName: "square.and.arrow.up")
                }
                .accessibilityLabel("Klus delen")
            }
        }
        .sheet(isPresented: $isShowingOwner) {
            NavigationStack {
                VStack(spacing: 16) {
                    avatar(size: 76)
                    Text(job.owner).font(.title2.bold())
                    Text("Buurtbewoner · \(job.distance) van jou")
                        .foregroundStyle(Color.textSecondary)
                    Text("Heeft ‘\(job.title)’ geplaatst.")
                        .multilineTextAlignment(.center)
                }
                .padding(24)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.paper)
                .navigationTitle("Geplaatst door")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Gereed") { isShowingOwner = false }
                    }
                }
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .tint(.textPrimary)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            if isHelping { helpingBanner }

            VStack(alignment: .leading, spacing: 6) {
                Text(job.title)
                    .font(.title2.bold())
                    .fixedSize(horizontal: false, vertical: true)
                Text("\(job.category.rawValue) · geplaatst \(job.postedAgo)")
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
            }

            requirements

            VStack(alignment: .leading, spacing: 6) {
                Text("In het kort")
                    .font(.caption.weight(.semibold))
                    .textCase(.uppercase)
                    .foregroundStyle(Color.brandGreen)
                Text(job.shortSummary)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.sage.opacity(0.3), in: .rect(cornerRadius: 16))
            .accessibilityElement(children: .combine)

            HStack(spacing: 0) {
                fact(value: job.distance, caption: "Afstand")
                Divider()
                fact(value: job.dateLabel, caption: "Wanneer")
                    .padding(.leading, 14)
                Divider()
                fact(value: job.duration.rawValue, caption: "Duur")
                    .padding(.leading, 14)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 12)
            .overlay(alignment: .top) { Divider() }
            .overlay(alignment: .bottom) { Divider() }

            VStack(alignment: .leading, spacing: 8) {
                Text("Omschrijving").font(.headline)
                Text(job.description)
                    .font(.body)
                    .foregroundStyle(Color.textSecondary)
                    .lineSpacing(4)
                    .lineLimit(isDescriptionExpanded ? nil : 3)
                    .fixedSize(horizontal: false, vertical: true)
                if job.description.count > 120 {
                    Button(isDescriptionExpanded ? "Minder tonen" : "Lees meer") {
                        withAnimation(.snappy) { isDescriptionExpanded.toggle() }
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.brandGreen)
                }
            }

            Button { isShowingOwner = true } label: {
                HStack(spacing: 12) {
                    avatar(size: 44)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Geplaatst door \(job.owner)").font(.headline)
                        Text("Buurtbewoner · \(job.distance) van jou")
                            .font(.footnote)
                            .foregroundStyle(Color.textSecondary)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.vertical, 14)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .overlay(alignment: .top) { Divider() }
            .overlay(alignment: .bottom) { Divider() }

            Text("Het exacte adres wordt niet openbaar getoond.")
                .font(.footnote)
                .foregroundStyle(Color.textSecondary)
        }
        .foregroundStyle(Color.textPrimary)
        .padding(20)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var helpingBanner: some View {
        Button { AppState.shared.openMyJobs(.helping) } label: {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Color.brandGreen)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Je hebt hulp aangeboden").font(.subheadline.weight(.semibold))
                    Text("Wacht op antwoord van \(job.owner). Bekijk het bij Mijn klussen.")
                        .font(.footnote)
                        .foregroundStyle(Color.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.textSecondary)
            }
            .padding(14)
            .background(Color.sage.opacity(0.35), in: .rect(cornerRadius: 16))
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityHint("Opent Mijn klussen")
    }

    private var requirements: some View {
        VStack(alignment: .leading, spacing: 8) {
            requirement(job.toolsLabel, icon: job.toolsIcon, positive: job.toolsProvided)
            if job.wasteRemoved {
                requirement("Afval wordt afgevoerd", icon: "trash.fill", positive: true)
            }
        }
    }

    private func requirement(_ text: String, icon: String, positive: Bool) -> some View {
        Label(text, systemImage: icon)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(positive ? Color.brandGreen : Color.accentOrange)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background((positive ? Color.sage : Color.accentOrange).opacity(positive ? 0.35 : 0.14), in: .capsule)
    }

    private func fact(value: String, caption: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(caption).font(.caption).foregroundStyle(Color.textSecondary)
            Text(value).font(.subheadline.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    private func avatar(size: CGFloat) -> some View {
        Text(job.owner.prefix(1).uppercased())
            .font(.headline)
            .foregroundStyle(Color.coffee)
            .frame(width: size, height: size)
            .background(Color.oat, in: .circle)
            .accessibilityHidden(true)
    }

    private var actionBar: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 0) {
                Text(activity.owns(job) ? "Jij betaalt" : "Jij verdient")
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                Text("€ \(job.pay)").font(.title3.bold())
            }
            .padding(.leading, 12)
            .accessibilityElement(children: .combine)
            Spacer(minLength: 0)
            if activity.owns(job) {
                Text("Je eigen klus")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.textSecondary)
                    .padding(12)
            } else {
                if isHelping {
                    Button("Aanbod intrekken") { isShowingWithdrawal = true }
                        .font(.headline)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 10)
                        .buttonStyle(.glass)
                        .foregroundStyle(Color.textPrimary)
                        .confirmationDialog("Je hulpaanbod intrekken?", isPresented: $isShowingWithdrawal,
                                            titleVisibility: .visible) {
                            Button("Aanbod intrekken", role: .destructive) {
                                activity.withdrawHelp(for: job)
                                AppState.shared.show("Je hulpaanbod is ingetrokken", icon: "arrow.uturn.backward.circle.fill",
                                                     style: .info)
                            }
                        }
                } else {
                    Button { isShowingOffer = true } label: {
                        Label("Ik wil helpen", systemImage: "hand.raised.fill")
                            .font(.headline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.brandGreen)
                    .foregroundStyle(.white)
                    .accessibilityHint("Bied aan om deze buurtbewoner te helpen en verdien € \(job.pay)")
                    .confirmationDialog("Wil je \(job.owner) helpen?", isPresented: $isShowingOffer,
                                        titleVisibility: .visible) {
                        Button("Ja, ik wil helpen") {
                            activity.offerHelp(for: job)
                            AppState.shared.show("Je helpt mee met ‘\(job.title)’", icon: "hand.thumbsup.fill",
                                                 destination: .helping)
                        }
                        Button("Annuleren", role: .cancel) {}
                    } message: {
                        Text("\(job.owner) krijgt je aanbod en jij verdient € \(job.pay) als je de klus doet.")
                    }
                }
            }
        }
        .foregroundStyle(Color.textPrimary)
        .padding(10)
        .glassEffect(.regular, in: .capsule)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

private struct PhotoGallery: View {
    let job: Job
    @State private var currentIndex = 0

    var body: some View {
        GeometryReader { geometry in
            Group {
                if job.photos.isEmpty {
                    placeholder
                } else {
                    TabView(selection: $currentIndex) {
                        ForEach(job.photos.indices, id: \.self) { index in
                            JobImage(url: job.photos[index], maxPoints: geometry.size.width) { placeholder }
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                                .tag(index)
                                .accessibilityLabel("Foto \(index + 1) van \(job.photos.count)")
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if job.photos.count > 1 {
                    Text("\(currentIndex + 1)/\(job.photos.count)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.45), in: .capsule)
                        .padding(16)
                        .accessibilityLabel("Foto \(currentIndex + 1) van \(job.photos.count)")
                }
            }
        }
    }

    private var placeholder: some View {
        Color.oat.overlay {
            Image(systemName: job.icon)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(Color.coffee.opacity(0.35))
                .accessibilityHidden(true)
        }
    }
}

#Preview {
    NavigationStack { JobDetailView(job: JobService.sampleJobs[0]) }
}
