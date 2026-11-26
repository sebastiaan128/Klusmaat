import Foundation

struct PostedJob: Codable, Identifiable {
    var id = UUID().uuidString
    var title: String
    var category: JobCategory
    var description: String
    var summary: String?
    var date: Date?
    var pay: Int
    var timing: JobTiming
    var duration: JobDuration
    var toolsProvided: Bool
    var wasteRemoved: Bool
    var createdAt = Date.now

    var job: Job {
        let hours = max(0, Int(Date.now.timeIntervalSince(createdAt) / 3600))
        return Job(
            id: id, title: title, category: category, distance: "0 m", distanceMeters: 0, pay: pay,
            dateLabel: dateLabel, timing: timing, duration: duration, hoursAgo: hours,
            toolsProvided: toolsProvided, wasteRemoved: wasteRemoved,
            description: description, summary: summary ?? "", owner: "Jij", postedAgo: postedAgo
        )
    }

    private var dateLabel: String {
        guard let date else { return timing.rawValue }
        let label = date.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated)
            .locale(Locale(identifier: "nl_NL")))
        return label.prefix(1).uppercased() + label.dropFirst()
    }

    static func timing(for date: Date?, calendar: Calendar = .current) -> JobTiming {
        guard let date else { return .flexible }
        return calendar.isDateInWeekend(date) ? .weekend : .thisWeek
    }

    private var postedAgo: String {
        if Date.now.timeIntervalSince(createdAt) < 60 { return "zojuist" }
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        return formatter.localizedString(for: createdAt, relativeTo: .now)
    }
}
