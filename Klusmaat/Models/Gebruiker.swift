//
//  Gebruiker.swift
//  Klusmaat
//
//  Models/ bevat de datamodellen van de app. Een Gebruiker is een account in de app (Firestore: users/{id}).
//  Veldnamen zijn gelijk aan de Firestore-velden die klusmaat-android en klusmaat-web gebruiken.
//

import Foundation

struct Gebruiker: Identifiable, Hashable, Codable {
    var id: String = ""
    var displayName: String = ""
    var neighbourhood: String = ""
    var photoUrl: String?
    var isOfferingHelp: Bool = false
    var isRequestingHelp: Bool = false
}
