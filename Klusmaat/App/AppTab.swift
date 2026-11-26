enum AppTab: Hashable, CaseIterable {
    case search
    case overview
    case replies
    case profile

    var title: String {
        switch self {
        case .search: "Zoeken"
        case .overview: "Mijn klussen"
        case .replies: "Reacties"
        case .profile: "Profiel"
        }
    }

    var icon: String {
        switch self {
        case .search: "magnifyingglass"
        case .overview: "list.bullet.clipboard"
        case .replies: "message"
        case .profile: "person"
        }
    }
}
