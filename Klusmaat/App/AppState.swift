import Foundation
import Observation

enum MyJobsSection: String, CaseIterable, Identifiable {
    case posted = "Geplaatst"
    case helping = "Ik help"
    var id: Self { self }
}

struct Toast: Identifiable, Equatable {
    enum Style { case success, info }

    let id = UUID()
    let message: String
    var icon = "checkmark.circle.fill"
    var style = Style.success
    var destination: MyJobsSection?
}

@MainActor
@Observable
final class AppState {
    static let shared = AppState()

    var selectedTab: AppTab = .search
    var myJobsSection = MyJobsSection.posted
    var toast: Toast?
    var isShowingPost = false
    var isTabBarHidden = false

    func show(_ message: String, icon: String = "checkmark.circle.fill",
              style: Toast.Style = .success, destination: MyJobsSection? = nil) {
        toast = Toast(message: message, icon: icon, style: style, destination: destination)
    }

    func openMyJobs(_ section: MyJobsSection) {
        myJobsSection = section
        selectedTab = .overview
    }
}
