import FirebaseAuth
import Foundation

final class AuthService {
  func registerUser(email: String, password: String, completion: @escaping (String?) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { _, error in
      completion(error.map { Self.registrationMessage(for: $0) })
    }
  }

  func signIn(email: String, password: String, completion: @escaping (String?) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { _, error in
      completion(error.map { Self.loginMessage(for: $0) })
    }
  }

  private static func loginMessage(for error: Error) -> String {
    switch AuthErrorCode(rawValue: (error as NSError).code) {
    case .invalidCredential, .wrongPassword, .userNotFound:
      "Het e-mailadres of wachtwoord is niet juist"
    case .tooManyRequests:
      "Te veel verzoeken. Probeer het later opnieuw"
    case .networkError:
      "Controleer je internetverbinding en probeer het opnieuw."
    default:
      "Er ging iets mis. Probeer het later opnieuw"
    }
  }

  private static func registrationMessage(for error: Error) -> String {
    switch AuthErrorCode(rawValue: (error as NSError).code) {
    case .emailAlreadyInUse:
      "E-mailadres is al in gebruik."
    case .invalidEmail:
      "Vul een geldig e-mailadres in."
    case .weakPassword:
      "Gebruik minimaal 6 tekens."
    case .networkError:
      "Controleer je internetverbinding en probeer het opnieuw."
    case .tooManyRequests:
      "Te veel verzoeken. Probeer het later opnieuw."
    default:
      "Er ging iets mis. Probeer het later opnieuw."
    }
  }
}
