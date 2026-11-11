//
//  AuthService.swift
//  Klusmaat
//
//  Services/ bevat logica die met externe systemen praat (later Firebase). Deze service regelt straks inloggen en registreren.
//
import FirebaseAuth

final class AuthService {
    
    // De completion geeft nil bij succes en anders de foutmelding.
    func registerUser(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            completion(error?.localizedDescription)
        }
    }

    func signIn(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            completion(error?.localizedDescription)
        }
    }
}
