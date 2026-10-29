//
//  Beoordeling.swift
//  Klusmaat
//
//  Models/ bevat de datamodellen van de app. Een Beoordeling is een review na een klus (Firestore: reviews/{id}).
//  Veldnamen zijn gelijk aan de Firestore-velden die klusmaat-android en klusmaat-web gebruiken.
//

import Foundation

struct Beoordeling: Identifiable, Hashable, Codable {
    var id: String = ""
    var jobId: String = ""
    var authorId: String = ""
    var subjectId: String = ""
    var score: Int = 0
    var text: String = ""
}
