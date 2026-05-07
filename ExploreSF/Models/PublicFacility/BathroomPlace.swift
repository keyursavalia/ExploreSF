import Foundation
import CoreLocation

struct BathroomPlace: Identifiable, Hashable {
    let id: String
    let name: String
    let address: String
    let hoursOpen: String?
    let hoursClose: String?
    let accessDays: String
    let isPublicAccess: Bool
    let park: String?
    let notes: String?
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
