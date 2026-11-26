import SwiftUI

struct ToastOverlay: View {
    private let state = AppState.shared

    var body: some View {
        ZStack {
            if let toast = state.toast {
                ToastView(toast: toast) {
                    if let destination = toast.destination { state.openMyJobs(destination) }
                    withAnimation(.snappy) { state.toast = nil }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .task(id: toast.id) {
                    try? await Task.sleep(for: .seconds(toast.destination == nil ? 3 : 5))
                    guard !Task.isCancelled else { return }
                    withAnimation(.snappy) { state.toast = nil }
                }
            }
        }
        .animation(.snappy, value: state.toast)
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }
}

private struct ToastView: View {
    let toast: Toast
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: toast.icon)
                    .font(.title3)
                    .foregroundStyle(toast.style == .success ? Color.brandGreen : Color.coffee)
                VStack(alignment: .leading, spacing: 2) {
                    Text(toast.message)
                        .font(.subheadline.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)
                    if toast.destination != nil {
                        Text("Tik om je klussen te bekijken")
                            .font(.footnote)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                Spacer(minLength: 0)
                if toast.destination != nil {
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .foregroundStyle(Color.textPrimary)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: 520)
            .glassEffect(.regular, in: .rect(cornerRadius: 20))
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityHint(toast.destination != nil ? "Opent Mijn klussen" : "Sluit de melding")
        .onAppear {
            AccessibilityNotification.Announcement(toast.message).post()
        }
    }
}
