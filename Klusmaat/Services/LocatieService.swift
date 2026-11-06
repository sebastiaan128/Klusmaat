//
//  LocatieService.swift
//  Klusmaat
//
//  Services/ praat met de buitenwereld. LocatieService vraagt toestemming voor de locatie en zoekt de postcode
//  van de gebruiker op, zodat het zoekscherm die alvast kan invullen.
//

import CoreLocation
import MapKit

enum LocatieService {
    /// Vraagt bij de eerste keer om toestemming en geeft daarna de postcode van de huidige plek, of nil als de
    /// gebruiker weigert of er geen postcode te vinden is.
    static func huidigePostcode() async -> String? {
        let sessie = CLServiceSession(authorization: .whenInUse)
        defer { sessie.invalidate() }

        do {
            for try await update in CLLocationUpdate.liveUpdates() {
                if update.authorizationDenied || update.authorizationDeniedGlobally || update.authorizationRestricted {
                    return nil
                }
                if let locatie = update.location {
                    return await postcode(bij: locatie)
                }
            }
        } catch {
            return nil
        }
        return nil
    }

    private static func postcode(bij locatie: CLLocation) async -> String? {
        guard let verzoek = MKReverseGeocodingRequest(location: locatie),
              let adres = try? await verzoek.mapItems.first?.address?.fullAddress
        else { return nil }

        // Nederlandse postcode zoals "3512 AB" uit het volledige adres halen
        return adres.firstMatch(of: /\d{4} ?[A-Z]{2}/).map { String($0.output) }
    }
}
