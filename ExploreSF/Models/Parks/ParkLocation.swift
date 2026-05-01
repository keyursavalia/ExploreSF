import Foundation
import SwiftData

@Model
final class ParkLocation {
    @Attribute(.unique) var id: String
    var name: String
    var acres: Double
    var propertyType: String
    var address: String
    var neighborhood: String
    var complex: String
    var latitude: Double
    var longitude: Double

    init(
        id: String, name: String, acres: Double, propertyType: String,
        address: String, neighborhood: String, complex: String,
        latitude: Double, longitude: Double
    ) {
        self.id           = id
        self.name         = name
        self.acres        = acres
        self.propertyType = propertyType
        self.address      = address
        self.neighborhood = neighborhood
        self.complex      = complex
        self.latitude     = latitude
        self.longitude    = longitude
    }
}
