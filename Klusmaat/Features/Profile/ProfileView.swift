import FirebaseAuth
import SwiftUI

struct ProfileView: View {
    @State private var profile = ProfileDetails.example

    var body: some View {
        ProfilePage {
            VStack(alignment: .leading, spacing: 28) {
                header
                statistics
                about
                personalDetails

                Button(action: signOut) {
                    Label("Uitloggen", systemImage: "rectangle.portrait.and.arrow.right")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, minHeight: 40)
                }
                .buttonStyle(.glass)
            }
            .padding(.bottom, 16)
        }
        .navigationTitle("Profiel")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink { EditProfileView(profile: $profile) } label: {
                    Image(systemName: "pencil")
                }
                .accessibilityLabel("Gegevens bewerken")
            }
        }
    }

    private func signOut() {
        do {
            try Auth.auth().signOut()
            AppState.shared.show("Je bent uitgelogd", icon: "rectangle.portrait.and.arrow.right", style: .info)
        } catch {
            AppState.shared.show("Uitloggen is niet gelukt. Probeer het opnieuw.",
                                 icon: "exclamationmark.triangle.fill", style: .info)
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(profile.initials)
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color.brandGreen)
                .frame(width: 72, height: 72)
                .background(Color.sage.opacity(0.5), in: .circle)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text(profile.name)
                    .font(.title2.bold())
                    .fixedSize(horizontal: false, vertical: true)
                Label(profile.city, systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
                Text("Lid sinds \(profile.memberSince)")
                    .font(.footnote)
                    .foregroundStyle(Color.textSecondary)

                Label("\(profile.rating) · \(profile.reviewCount) reviews", systemImage: "star.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.brandGreen)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.sage.opacity(0.3), in: .capsule)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var statistics: some View {
        HStack(spacing: 16) {
            statistic(profile.jobsPosted, label: "Klussen geplaatst")
            Rectangle()
                .fill(Color.linen)
                .frame(width: 1, height: 36)
                .accessibilityHidden(true)
            statistic(profile.timesHelped, label: "Keer geholpen")
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 12)
        .background(Color.cream, in: .rect(cornerRadius: 20))
    }

    private func statistic(_ count: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Text(count, format: .number)
                .font(.title2.bold())
            Text(label)
                .font(.caption)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    private var about: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader("Over mij", accessibilityLabel: "Over mij bewerken")
            Text(profile.about)
                .font(.body)
                .foregroundStyle(Color.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var personalDetails: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("Persoonsgegevens", accessibilityLabel: "Persoonsgegevens bewerken")
                .padding(.bottom, 4)
            detail("Naam", value: profile.name, icon: "person")
            Divider().overlay(Color.linen)
            detail("E-mailadres", value: profile.email, icon: "envelope")
            Divider().overlay(Color.linen)
            detail("Woonplaats", value: profile.city, icon: "mappin.and.ellipse")
        }
    }

    private func sectionHeader(_ title: String, accessibilityLabel: String) -> some View {
        HStack(spacing: 8) {
            Text(title).font(.headline)
            Spacer(minLength: 0)
            NavigationLink { EditProfileView(profile: $profile) } label: {
                Image(systemName: "pencil")
                    .font(.subheadline)
                    .foregroundStyle(Color.brandGreen)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(accessibilityLabel)
        }
    }

    private func detail(_ label: String, value: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .foregroundStyle(Color.textSecondary)
                .frame(width: 20)
                .padding(.top, 16)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(Color.textSecondary)
                Text(value)
                    .font(.body)
                    .textSelection(.enabled)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 12)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack { ProfileView() }
}
