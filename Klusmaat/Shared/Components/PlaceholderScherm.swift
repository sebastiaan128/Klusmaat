//
//  PlaceholderScherm.swift
//  Klusmaat
//
//  Tijdelijk scherm voor features die nog geport moeten worden (tegenhanger van StubScreen in klusmaat-android).
//

import SwiftUI

struct PlaceholderScherm: View {
    let titel: String
    let referentie: String
    let hint: String

    var body: some View {
        VStack(spacing: 12) {
            Text(titel)
                .font(.titel(24))
                .foregroundStyle(Color.tekstPrimair)
            Text(hint)
                .font(.tekst(14))
                .foregroundStyle(Color.tekstGedempt)
            Text(referentie)
                .font(.tekst(11, weight: .medium))
                .foregroundStyle(Color.coffee)
                .padding(.top, 8)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.achtergrond)
    }
}

#Preview {
    PlaceholderScherm(titel: "Klus plaatsen", referentie: "§7.2", hint: "Komt in een volgende stap.")
}
