import SwiftUI

struct ProfilePage<Content: View>: View {
  @ViewBuilder var content: Content

  var body: some View {
    ScrollView {
      content
        .frame(maxWidth: 520)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
    .scrollIndicators(.hidden)
    .scrollDismissesKeyboard(.interactively)
    .background(Color.paper)
    .foregroundStyle(Color.textPrimary)
    .tint(.brandGreen)
  }
}
