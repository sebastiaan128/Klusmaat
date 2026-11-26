import SwiftUI

struct EditProfileView: View {
    private enum Field: Hashable {
        case name
        case email
        case city
        case about
    }

    @Binding private var profile: ProfileDetails
    @State private var draft: ProfileDetails
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    init(profile: Binding<ProfileDetails>) {
        _profile = profile
        _draft = State(initialValue: profile.wrappedValue)
    }

    private var canSave: Bool {
        !draft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && draft.email.isValidEmail
    }

    var body: some View {
        ProfilePage {
            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Persoonsgegevens")
                        .font(.headline)
                    VStack(spacing: 12) {
                        AuthInput(icon: "person", isFocused: focusedField == .name) {
                            TextField("Naam", text: $draft.name)
                                .textContentType(.name)
                                .focused($focusedField, equals: .name)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .email }
                        }
                        AuthInput(icon: "envelope", isFocused: focusedField == .email) {
                            TextField("E-mailadres", text: $draft.email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .email)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .city }
                        }
                        AuthInput(icon: "mappin.and.ellipse", isFocused: focusedField == .city) {
                            TextField("Woonplaats", text: $draft.city)
                                .textContentType(.addressCity)
                                .focused($focusedField, equals: .city)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .about }
                        }
                    }
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Over mij")
                        .font(.headline)
                    TextField("Over mij", text: $draft.about, axis: .vertical)
                        .font(.body)
                        .lineLimit(4...8)
                        .focused($focusedField, equals: .about)
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.7), in: .rect(cornerRadius: 20))
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(focusedField == .about ? Color.brandGreen.opacity(0.45) : Color.linen, lineWidth: 1)
                                .allowsHitTesting(false)
                        }
                }

                Button(action: save) {
                    Text("Opslaan")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 40)
                }
                .buttonStyle(.glassProminent)
                .tint(.brandGreen)
                .disabled(!canSave)
            }
        }
        .navigationTitle("Gegevens bewerken")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Annuleer") { dismiss() }
                    .foregroundStyle(Color.brandGreen)
            }
        }
    }

    private func save() {
        guard canSave else { return }
        focusedField = nil
        draft.name = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        draft.email = draft.email.trimmingCharacters(in: .whitespacesAndNewlines)
        draft.city = draft.city.trimmingCharacters(in: .whitespacesAndNewlines)
        profile = draft
        dismiss()
        AppState.shared.show("Je gegevens zijn opgeslagen")
    }
}

#Preview {
    NavigationStack { EditProfileView(profile: .constant(.example)) }
}
