import Foundation
import Testing
@testable import Klusmaat

struct JobBehaviorTests {
    @Test func combinesCategoryDistanceAndRefinements() {
        let filters = JobFilters(category: .garden, radiusKm: 1, minPay: 30, maxPay: 50,
                                 durations: [.halfDay], toolsProvided: true, onlyNew: true)
        #expect(JobService.sampleJobs.matching(filters).map(\.id) == ["1"])
        #expect(filters.refinementCount == 5)
        #expect(filters.withoutRefinements() == JobFilters(category: .garden, radiusKm: 1))
        #expect(JobService.sampleJobs.matching(JobFilters(category: .assembly)).map(\.id) == ["2"])
        #expect(JobService.sampleJobs.matching(JobFilters(minPay: 500)).isEmpty)
    }

    @Test func sortsByDistancePayAndRecency() {
        let jobs = JobService.sampleJobs
        #expect(JobSortOrder.nearest.sort(jobs).first?.id == "1")
        #expect(JobSortOrder.highestPay.sort(jobs).first?.id == "12")
        #expect(JobSortOrder.newest.sort(jobs).first?.id == "6")
    }

    @MainActor
    @Test func indexedSearchPreservesMatchingAndOrdering() {
        let jobs = JobService.sampleJobs
        let search = JobSearch(jobs: jobs)
        for order in JobSortOrder.allCases {
            search.sortOrder = order
            for filters in [JobFilters(), JobFilters(category: .garden, radiusKm: 1),
                            JobFilters(minPay: 30, durations: [.halfDay], toolsProvided: true)] {
                search.filters = filters
                for query in ["", "  SNOEIEN  ", "koffie", "repareren", "geen enkele match"] {
                    search.query = query
                    let text = query.trimmingCharacters(in: .whitespacesAndNewlines)
                    let expected = order.sort(jobs.matching(filters).filter {
                        text.isEmpty || "\($0.title) \($0.description) \($0.category.rawValue)".localizedStandardContains(text)
                    })
                    #expect(search.results.map(\.id) == expected.map(\.id))
                }
            }
        }
    }

    @MainActor
    @Test func offersAreUniquePersistentAndWithdrawable() {
        let defaults = MemoryDefaults()
        let activity = JobActivity(defaults: defaults)
        let job = JobService.sampleJobs[0]
        activity.offerHelp(for: job)
        activity.offerHelp(for: job)
        #expect(activity.helpingJobs.map(\.id) == [job.id])
        let restored = JobActivity(defaults: defaults)
        #expect(restored.offeredIDs.contains(job.id))
        restored.withdrawHelp(for: job)
        #expect(JobActivity(defaults: defaults).helpingJobs.isEmpty)
        activity.offerHelp(for: JobService.sampleJobs[1])
        #expect(!activity.offeredIDs.contains("2"))
    }

    @MainActor
    @Test func savesSurviveReload() {
        let defaults = MemoryDefaults()
        let activity = JobActivity(defaults: defaults)
        let sample = JobService.sampleJobs[0]
        activity.toggleSaved(sample)
        #expect(JobActivity(defaults: defaults).savedIDs.contains(sample.id))
        activity.toggleSaved(sample)
        #expect(JobActivity(defaults: defaults).savedIDs.isEmpty)

    }
}

private final class MemoryDefaults: UserDefaults, @unchecked Sendable {
    private var values: [String: Any] = [:]
    override func stringArray(forKey key: String) -> [String]? { values[key] as? [String] }
    override func set(_ value: Any?, forKey key: String) { values[key] = value }
}
