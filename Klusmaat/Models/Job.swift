import Foundation

enum JobCategory: String, CaseIterable, Identifiable, Codable {
    case garden = "Tuinieren"
    case indoor = "Binnen"
    case repair = "Repareren"
    case painting = "Verven"
    case assembly = "Meubels monteren"
    case pickup = "Ophalen"

    var id: Self { self }

    var icon: String {
        switch self {
        case .garden: "leaf"
        case .indoor: "house"
        case .repair: "hammer"
        case .painting: "paintbrush"
        case .assembly: "sofa"
        case .pickup: "shippingbox"
        }
    }
}

enum JobTiming: String, CaseIterable, Identifiable, Codable {
    case thisWeek = "Deze week"
    case weekend = "In het weekend"
    case flexible = "Datum flexibel"

    var id: Self { self }
}

enum JobDuration: String, CaseIterable, Identifiable, Codable {
    case short = "Korter dan 2 uur"
    case halfDay = "Halve dag"
    case fullDay = "Hele dag of langer"

    var id: Self { self }
}

struct Job: Identifiable {
    let id: String
    let title: String
    let category: JobCategory
    let distance: String
    let distanceMeters: Int
    let pay: Int
    var dateLabel = JobTiming.flexible.rawValue
    var timing = JobTiming.flexible
    var duration = JobDuration.short
    let hoursAgo: Int
    var photos: [URL] = []
    var toolsProvided = false
    var wasteRemoved = false
    let description: String
    var summary = ""
    let owner: String
    let postedAgo: String

    var icon: String {
        if title.localizedCaseInsensitiveContains("fiets") { return "bicycle" }
        if title.localizedCaseInsensitiveContains("dakgoot") { return "sparkle" }
        return category.icon
    }

    var isNew: Bool { hoursAgo < 12 }

    var shortSummary: String {
        if !summary.isEmpty { return summary }
        let firstSentence = description.split(whereSeparator: { ".!?".contains($0) }).first.map(String.init)
        return (firstSentence ?? description).trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var toolsLabel: String { toolsProvided ? "Gereedschap is aanwezig" : "Neem zelf gereedschap mee" }
    var toolsIcon: String { toolsProvided ? "checkmark.seal.fill" : "bag.fill" }
}
