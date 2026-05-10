import Foundation
import CoreLocation

/// Value type representation of a Recreation & Parks property.
struct ParkPlace: Identifiable, Hashable {
    let id: String
    let name: String
    let acres: Double
    let propertyType: String
    let address: String
    let neighborhood: String
    let complex: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var acresFormatted: String {
        acres >= 10
            ? String(format: "%.0f acres", acres)
            : String(format: "%.1f acres", acres)
    }
}

