import Foundation
import Observation

@MainActor
@Observable
final class JobActivity {
    static let shared = JobActivity()

    private let defaults: UserDefaults
    private(set) var offeredIDs: Set<String>
    private(set) var savedIDs: Set<String>
    private(set) var posted: [PostedJob]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        offeredIDs = Set(defaults.stringArray(forKey: "jobs.offered") ?? [])
        savedIDs = Set(defaults.stringArray(forKey: "jobs.saved") ?? [])
        posted = defaults.data(forKey: "jobs.posted")
            .flatMap { try? JSONDecoder().decode([PostedJob].self, from: $0) } ?? []
    }

    var postedJobs: [Job] { posted.map(\.job) }
    var jobs: [Job] { postedJobs + JobService.sampleJobs }
    var myJobs: [Job] { postedJobs + JobService.sampleJobs.filter { ["2", "8", "11"].contains($0.id) } }
    var helpingJobs: [Job] { jobs.filter { offeredIDs.contains($0.id) } }

    func owns(_ job: Job) -> Bool { myJobs.contains { $0.id == job.id } }

    func toggleSaved(_ job: Job) {
        if savedIDs.contains(job.id) { savedIDs.remove(job.id) }
        else { savedIDs.insert(job.id) }
        defaults.set(savedIDs.sorted(), forKey: "jobs.saved")
    }

    func offerHelp(for job: Job) {
        guard !owns(job) else { return }
        offeredIDs.insert(job.id)
        defaults.set(offeredIDs.sorted(), forKey: "jobs.offered")
    }

    func withdrawHelp(for job: Job) {
        offeredIDs.remove(job.id)
        defaults.set(offeredIDs.sorted(), forKey: "jobs.offered")
    }

    func post(_ job: PostedJob) {
        posted.insert(job, at: 0)
        defaults.set(try? JSONEncoder().encode(posted), forKey: "jobs.posted")
    }
}
