import Foundation

enum JobSortOrder: String, CaseIterable, Identifiable {
    case newest = "Nieuwste eerst"
    case nearest = "Dichtstbij"
    case highestPay = "Hoogste vergoeding"

    var id: Self { self }

    func sort(_ jobs: [Job]) -> [Job] {
        switch self {
        case .newest: jobs.sorted { $0.hoursAgo < $1.hoursAgo }
        case .nearest: jobs.sorted { $0.distanceMeters < $1.distanceMeters }
        case .highestPay: jobs.sorted { $0.pay > $1.pay }
        }
    }
}

struct JobFilters: Equatable {
    var category: JobCategory?
    var postalCode = ""
    var radiusKm: Int? = 10
    var minPay: Int?
    var maxPay: Int?
    var timing: JobTiming?
    var durations: Set<JobDuration> = []
    var toolsProvided = false
    var wasteRemoved = false
    var onlyNew = false

    static let radii: [Int?] = [1, 2, 5, 10, nil]
    static let minPayOptions = [10, 25, 50]

    var title: String { category?.rawValue ?? "Alle soorten" }

    var locationLabel: String {
        let place = postalCode.trimmingCharacters(in: .whitespaces).uppercased()
        return "\(place.isEmpty ? "Jouw buurt" : place) · \(radiusKm.map { "\($0) km" } ?? "overal")"
    }

    var refinementCount: Int {
        [minPay != nil, maxPay != nil, timing != nil, toolsProvided, wasteRemoved, onlyNew]
            .filter { $0 }.count + durations.count
    }

    func withoutRefinements() -> JobFilters {
        JobFilters(category: category, postalCode: postalCode, radiusKm: radiusKm)
    }

    func matches(_ job: Job) -> Bool {
        (category == nil || job.category == category)
            && (radiusKm.map { job.distanceMeters <= $0 * 1000 } ?? true)
            && (minPay.map { job.pay >= $0 } ?? true)
            && (maxPay.map { job.pay <= $0 } ?? true)
            && (timing.map { job.timing == $0 } ?? true)
            && (durations.isEmpty || durations.contains(job.duration))
            && (!toolsProvided || job.toolsProvided)
            && (!wasteRemoved || job.wasteRemoved)
            && (!onlyNew || job.isNew)
    }
}

extension Array where Element == Job {
    func matching(_ filters: JobFilters) -> [Job] {
        filter(filters.matches)
    }
}

func jobsLabel(_ count: Int, category: JobCategory?) -> String {
    switch category {
    case .garden: count == 1 ? "1 tuinklus" : "\(count) tuinklussen"
    case .indoor: count == 1 ? "1 klus binnen" : "\(count) klussen binnen"
    case .repair: count == 1 ? "1 reparatie" : "\(count) reparaties"
    case .painting, .assembly, .pickup: count == 1 ? "1 klus" : "\(count) klussen"
    case nil: count == 1 ? "1 klus" : "\(count) klussen"
    }
}
