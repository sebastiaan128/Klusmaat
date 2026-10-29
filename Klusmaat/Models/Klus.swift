//
//  Klus.swift
//  Klusmaat
//
//  Models/ bevat de datamodellen van de app. Een Klus is een klus die iemand plaatst (Firestore: jobs/{id}).
//  Veldnamen zijn gelijk aan de Firestore-velden die klusmaat-android en klusmaat-web gebruiken.
//

import Foundation

struct Klus: Identifiable, Hashable, Codable {
    var id: String = ""
    var ownerId: String = ""
    var title: String = ""
    var description: String = ""
    var category: String = ""
    var status: String = "open"
    var requestedAt: Date?
}
