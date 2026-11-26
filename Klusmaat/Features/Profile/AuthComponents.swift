import SwiftUI

struct AuthInput<Content: View>: View {
    let icon: String
    var isFocused = false
    var hasTrailingControl = false
    @ViewBuilder var content: Content

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.textSecondary)
                .frame(width: 20)
                .accessibilityHidden(true)
            content
        }
        .font(.body)
        .padding(.leading, 18)
        .padding(.trailing, hasTrailingControl ? 6 : 18)
        .frame(minHeight: 56)
        .background(Color.white.opacity(0.7), in: .capsule)
        .overlay {
            Capsule()
                .stroke(isFocused ? Color.brandGreen.opacity(0.45) : Color.linen, lineWidth: 1)
                .allowsHitTesting(false)
        }
    }
}

struct AuthDivider: View {
    var body: some View {
        HStack(spacing: 16) {
            Rectangle().fill(Color.linen).frame(height: 1)
            Text("of")
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
            Rectangle().fill(Color.linen).frame(height: 1)
        }
        .padding(.vertical, 24)
    }
}

struct GoogleSignInLink: View {
    var body: some View {
        NavigationLink { HomeView() } label: {
            HStack(spacing: 12) {
                Image("Google_Symbol_0")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("Inloggen met Google")
            }
            .font(.body.weight(.semibold))
            .foregroundStyle(Color.textPrimary)
            .frame(maxWidth: .infinity, minHeight: 40)
        }
        .buttonStyle(.glass)
    }
}
