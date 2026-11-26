import SwiftUI

struct RootView: View {
    @State private var isShowingPost = false
    private let state = AppState.shared

    var body: some View {
        TabView(selection: tabSelection) {
            tab(.search) { HomeView() }
            tab(.overview) { OverviewView() }
            tab(.replies) { MessagesView() }
            tab(.profile) { AccountView() }

            Tab(value: .post, role: .prominent) {
                Color.clear
            } label: {
                Label {
                    Text(AppTab.post.title)
                } icon: {
                    Image(uiImage: postIcon)
                        .renderingMode(.original)
                }
            }
            .accessibilityLabel("Klus plaatsen")
        }
        .background(KeyboardDismissOnTap())
        .tint(.brandGreen)
        .overlay(alignment: .top) { ToastOverlay() }
        .sheet(isPresented: $isShowingPost) {
            PostJobView { AppState.shared.openMyJobs(.posted) }
        }
    }

    private func tab(_ tab: AppTab, @ViewBuilder content: () -> some View) -> some TabContent<AppTab> {
        Tab(value: tab, content: content) {
            Label {
                Text(tab.title)
            } icon: {
                Image(uiImage: icon(tab.icon))
                    .environment(\.symbolVariants, .none)
            }
        }
    }

    private func icon(_ name: String) -> UIImage {
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular)
        return UIImage(systemName: name, withConfiguration: configuration) ?? UIImage()
    }

    private var postIcon: UIImage {
        let configuration = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
        return UIImage(systemName: "plus.circle.fill", withConfiguration: configuration)?
            .withTintColor(UIColor(Color.accentOrange), renderingMode: .alwaysOriginal) ?? UIImage()
    }

    private var tabSelection: Binding<AppTab> {
        Binding {
            state.selectedTab
        } set: { tab in
            if tab == .post {
                isShowingPost = true
            } else {
                state.selectedTab = tab
            }
        }
    }
}

#Preview {
    RootView()
}
