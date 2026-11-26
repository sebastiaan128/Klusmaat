import SwiftUI

struct OverviewView: View {
    @State private var isShowingPost = false
    private let activity = JobActivity.shared
    @Bindable private var state = AppState.shared

    private var section: MyJobsSection { state.myJobsSection }

    private var jobs: [Job] { section == .posted ? activity.myJobs : activity.helpingJobs }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Mijn klussen", selection: $state.myJobsSection) {
                    ForEach(MyJobsSection.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.bottom, 4)

                if jobs.isEmpty {
                    ContentUnavailableView {
                        Label(section == .posted ? "Nog geen klussen geplaatst" : "Je helpt nog niet mee",
                              systemImage: "list.bullet.clipboard")
                    } description: {
                        Text(section == .posted
                             ? "Klussen die je plaatst, zie je hier terug. Ook de reacties van buren."
                             : "Bied je hulp aan bij een klus in je buurt. Je vindt je aanbod hier terug.")
                    } actions: {
                        if section == .posted {
                            Button("Plaats een klus") { isShowingPost = true }
                                .buttonStyle(.borderedProminent)
                                .tint(.brandGreen)
                        }
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(jobs) { job in
                                NavigationLink { JobDetailView(job: job) } label: {
                                    JobRow(job: job,
                                           status: section == .posted ? "Nog geen reacties" : "● Wacht op antwoord van \(job.owner)",
                                           highlighted: section == .helping)
                                }
                                .buttonStyle(.plain)
                                Divider().overlay(Color.linen)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .background(Color.paper)
            .navigationTitle("Mijn klussen")
            .sheet(isPresented: $isShowingPost) { PostJobView { state.myJobsSection = .posted } }
            .tint(.brandGreen)
        }
    }
}

#Preview { OverviewView() }
