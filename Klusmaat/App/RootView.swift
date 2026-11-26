import SwiftUI

struct RootView: View {
    @Bindable private var state = AppState.shared

    var body: some View {
        TabView(selection: tabSelection) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Tab(value: tab) {
                    content(for: tab)
                } label: {
                    Label {
                        Text(tab.title)
                    } icon: {
                        Image(uiImage: icon(tab.icon))
                            .environment(\.symbolVariants, .none)
                    }
                }
            }

            Tab(value: AppTab?.none, role: .prominent) {
                Color.clear
            } label: {
                Label("Klus plaatsen", systemImage: "plus")
            }
        }
        .background(KeyboardDismissOnTap())
        .tint(.brandGreen)
        .overlay {
            ZStack(alignment: .bottomTrailing) {
                Color.clear
                if !state.isTabBarHidden { postButtonFace }
            }
            .ignoresSafeArea()
            .allowsHitTesting(false)
        }
        .sheet(isPresented: $state.isShowingPost) {
            PostJobView {
                state.show("Je klus is geplaatst", icon: "checkmark.circle.fill", destination: .posted)
            }
        }
    }

    private var postButtonFace: some View {
        Image(systemName: "plus")
            .font(.title2.weight(.semibold))
            .foregroundStyle(.white)
            .frame(width: 62, height: 62)
            .glassEffect(.regular.tint(.brandGreen), in: .circle)
            .padding(.trailing, 21)
            .padding(.bottom, 21)
            .accessibilityHidden(true)
    }

    @ViewBuilder
    private func content(for tab: AppTab) -> some View {
        switch tab {
        case .search: HomeView()
        case .overview: OverviewView()
        case .replies: MessagesView()
        case .profile: AccountView()
        }
    }

    private func icon(_ name: String) -> UIImage {
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular)
        return UIImage(systemName: name, withConfiguration: configuration) ?? UIImage()
    }

    private var tabSelection: Binding<AppTab?> {
        Binding {
            state.selectedTab
        } set: { tab in
            if let tab { state.selectedTab = tab } else { state.isShowingPost = true }
        }
    }
}

#Preview {
    RootView()
}
