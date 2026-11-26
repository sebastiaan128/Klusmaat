import CoreLocation
import MapKit

enum LocationService {
    static func currentPostalCode() async -> String? {
        let session = CLServiceSession(authorization: .whenInUse)
        defer { session.invalidate() }

        do {
            for try await update in CLLocationUpdate.liveUpdates() {
                if update.authorizationDenied || update.authorizationDeniedGlobally || update.authorizationRestricted {
                    return nil
                }
                if let location = update.location {
                    return await postalCode(at: location)
                }
            }
        } catch {
            return nil
        }
        return nil
    }

    private static func postalCode(at location: CLLocation) async -> String? {
        guard let request = MKReverseGeocodingRequest(location: location),
              let address = try? await request.mapItems.first?.address?.fullAddress
        else { return nil }

        return address.firstMatch(of: /\d{4} ?[A-Z]{2}/).map { String($0.output) }
    }
}
