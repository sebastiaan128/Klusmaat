import SwiftUI

struct MailSendView: View {
  var body: some View {
    ProfilePage {

      VStack {
        Image(systemName: "envelope.badge")
          .font(.system(size: 100))

        Text("E-mail Verzonden")
          .font(.largeTitle)
          .fontWeight(.bold)
          .padding(.top, 20)
          .multilineTextAlignment(.center)
          .padding(.bottom, 20)

        Text("Controleer je inbox voor een wachtwoord-resetlink.")
          .foregroundColor(Color.textSecondary)
          .multilineTextAlignment(.center)
          .padding(.bottom, 20)

        NavigationLink(destination: LoginView()) {
          Text("Terug naar inloggen")
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 50)
            .background(Color.brandGreen)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
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
  NavigationStack { MailSendView() }
}
