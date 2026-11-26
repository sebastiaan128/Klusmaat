import SwiftUI

struct ForgotPasswordView: View {

  @State private var email = ""
  @FocusState private var isFieldFocused: String?

  var body: some View {
    ProfilePage {

      VStack {
        Text("Wachtwoord Vergeten")
          .font(.largeTitle)
          .fontWeight(.bold)
          .padding(.top, 20)
          .multilineTextAlignment(.center)
          .padding(.bottom, 20)

        Text(
          "Voer je e-mailadres in om een resetlink te ontvangen."
        )
        .foregroundColor(Color.textSecondary)
        .multilineTextAlignment(.center)

        TextField("E-mailadres", text: $email)
          .textContentType(.emailAddress)
          .keyboardType(.emailAddress)
          .multilineTextAlignment(.leading)
          .padding(.leading, 15)
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
          .frame(maxWidth: .infinity, minHeight: 50)
          .background(Color.white)
          .cornerRadius(10)
          .multilineTextAlignment(.leading)
          .clipShape(RoundedRectangle(cornerRadius: 10))
          .focused($isFieldFocused, equals: "e-mail")
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .stroke(
                isFieldFocused == "e-mail"
                  ? Color.brandGreen : Color.sand,
                lineWidth: 1
              )
          )
          .padding(.bottom, 10)
          .padding(.top, 10)

        NavigationLink(destination: MailSendView()) {
          Text("Verstuur Link")
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 50)
            .background(Color.brandGreen)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .disabled(!email.isValidEmail)
        .opacity(email.isValidEmail ? 1 : 0.45)
      }
      .padding(25)
      .frame(maxWidth: .infinity)
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .overlay(
        RoundedRectangle(cornerRadius: 20)
          .stroke(Color.sand, lineWidth: 1)
      )
    }
  }
}

#Preview {
  NavigationStack { ForgotPasswordView() }
}
