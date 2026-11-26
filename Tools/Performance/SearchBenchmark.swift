import Foundation

@main
struct Benchmark {
    @MainActor static func main() throws {
        let jobs = Array(repeating: JobService.sampleJobs, count: 1000).flatMap { $0 }
        let indexStart = Date()
        let search = JobSearch(jobs: jobs)
        let indexTime = Date().timeIntervalSince(indexStart)
        let queries = ["", "he", "heg", "verf", "TUIN", "kraan", "kast", "boor", "\n snoeien  ", "geen enkele match"]
        var checksum = 0
        for run in 1...3 {
            let oldStart = Date()
            for query in queries {
                let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
                for _ in 0..<4 {
                    let result = JobSortOrder.newest.sort(jobs.matching(JobFilters()).filter {
                        trimmed.isEmpty || "\($0.title) \($0.description) \($0.category.rawValue)".localizedStandardContains(trimmed)
                    })
                    checksum += result.count
                }
            }
            let oldTime = Date().timeIntervalSince(oldStart)
            let newStart = Date()
            for query in queries {
                search.query = query
                for _ in 0..<4 { checksum += search.results.count }
            }
            let newTime = Date().timeIntervalSince(newStart)
            for order in JobSortOrder.allCases {
                search.sortOrder = order
                for filter in [JobFilters(), JobFilters(category: .garden, radiusKm: 1, minPay: 30), JobFilters(durations: [.short], toolsProvided: true)] {
                    search.filters = filter
                    for query in queries {
                        search.query = query
                        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
                        let expected = order.sort(jobs.matching(filter).filter {
                            trimmed.isEmpty || "\($0.title) \($0.description) \($0.category.rawValue)".localizedStandardContains(trimmed)
                        })
                        precondition(search.results.map(\.id) == expected.map(\.id), "Resultaten veranderd")
                    }
                }
            }
            search.filters = JobFilters(); search.sortOrder = .newest; search.query = "reset"
            print("run \(run): oud \(String(format: "%.3f", oldTime))s; nieuw \(String(format: "%.3f", newTime))s; factor \(String(format: "%.2f", oldTime / newTime))")
        }
        print("Indexopbouw voor \(jobs.count) klussen: \(String(format: "%.3f", indexTime))s; checksum \(checksum)")
    }
}
