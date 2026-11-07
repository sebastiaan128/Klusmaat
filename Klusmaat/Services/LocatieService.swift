import CoreLocation
import MapKit

enum LocatieService {
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

        return adres.firstMatch(of: /\d{4} ?[A-Z]{2}/).map { String($0.output) }
    }
}
