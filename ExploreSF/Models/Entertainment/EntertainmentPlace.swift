import Foundation
import CoreLocation

struct EntertainmentPlace: Identifiable, Hashable {
    let id:           String
    let name:         String
    let address:      String
    let licenseType:  String   // simplified/normalized display value
    let neighborhood: String
    let latitude:     Double
    let longitude:    Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static func simplifiedLicenseType(_ raw: String) -> String {
        if raw.contains("Limited Live Performance") { return "Live Performance" }
        if raw.contains("Place of Entertainment")   { return "Venue" }
        if raw.contains("Fixed Place Amplified Sound") { return "Amplified Sound" }
        if raw.contains("Extended Hours")           { return "Extended Hours" }
        if raw.contains("Billiard")                 { return "Billiards & Pool" }
        if raw.contains("Mechanical Amusement")     { return "Arcade & Amusement" }
        return "Other"
    }
}
