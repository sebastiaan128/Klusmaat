import Foundation

struct ProfileDetails: Equatable {
    var name: String
    var email: String
    var city: String
    var about: String
    let memberSince: String
    let rating: String
    let reviewCount: Int
    let jobsPosted: Int
    let timesHelped: Int

    var initials: String {
        let words = name.split(whereSeparator: \.isWhitespace)
        guard let first = words.first?.first else { return "?" }
        let last = words.count > 1 ? words.last?.first : nil
        return (String(first) + (last.map(String.init) ?? "")).uppercased()
    }

    static let example = ProfileDetails(
        name: "Sanne de Vries",
        email: "sanne@voorbeeld.nl",
        city: "Utrecht",
        about: "Handig met verf en gereedschap en ik vind het leuk om buren te helpen. Vooral in het weekend beschikbaar.",
        memberSince: "maart 2026",
        rating: "4.8",
        reviewCount: 12,
        jobsPosted: 5,
        timesHelped: 9
    )
}
