//
//  GereedschapItem.swift
//  Klusmaat
//
//  Models/ bevat de datamodellen van de app. Een GereedschapItem is gereedschap dat iemand uitleent (Firestore: tools/{id}).
//  Veldnamen zijn gelijk aan de Firestore-velden die klusmaat-android en klusmaat-web gebruiken.
//

import Foundation

struct GereedschapItem: Identifiable, Hashable, Codable {
    var id: String = ""
    var ownerId: String = ""
    var name: String = ""
    var description: String = ""
    var available: Bool = true
}
