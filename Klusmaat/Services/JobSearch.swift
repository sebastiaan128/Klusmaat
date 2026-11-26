import Foundation
import Observation

@MainActor
@Observable
final class JobSearch {
    var query = "" { didSet { if query != oldValue { update() } } }
    var filters = JobFilters() { didSet { if filters != oldValue { update() } } }
    var sortOrder = JobSortOrder.newest { didSet { if sortOrder != oldValue { update() } } }
    private(set) var results: [Job] = []

    private struct Entry {
        let job: Job
        let text: String
    }

    @ObservationIgnored private var ordered: [JobSortOrder: [Entry]] = [:]

    init(jobs: [Job]) {
        setJobs(jobs)
    }

    func setJobs(_ jobs: [Job]) {
        let entries = jobs.map { Entry(job: $0, text: "\($0.title) \($0.description) \($0.category.rawValue)") }
        ordered = Dictionary(uniqueKeysWithValues: JobSortOrder.allCases.map { order in
            let sorted = entries.sorted { lhs, rhs in
                switch order {
                case .newest: lhs.job.hoursAgo < rhs.job.hoursAgo
                case .nearest: lhs.job.distanceMeters < rhs.job.distanceMeters
                case .highestPay: lhs.job.pay > rhs.job.pay
                }
            }
            return (order, sorted)
        })
        update()
    }

    private func update() {
        let text = query.trimmingCharacters(in: .whitespacesAndNewlines)
        results = (ordered[sortOrder] ?? []).compactMap { entry in
            guard filters.matches(entry.job),
                  text.isEmpty || entry.text.localizedStandardContains(text)
            else { return nil }
            return entry.job
        }
    }
}
