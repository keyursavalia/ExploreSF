import Foundation
import SwiftData

@Model
final class POPOSLocation {
    @Attribute(.unique) var id: String
    var name: String
    var address: String
    var hours: String
    var spaceType: String
    var descriptionText: String
    var hasFood: Bool
    var hasArt: Bool
    var hasRestrooms: Bool
    var isIndoor: Bool
    var seatingInfo: String
    var latitude: Double
    var longitude: Double

    init(
        id: String, name: String, address: String, hours: String, spaceType: String,
        descriptionText: String, hasFood: Bool, hasArt: Bool, hasRestrooms: Bool,
        isIndoor: Bool, seatingInfo: String, latitude: Double, longitude: Double
    ) {
        self.id              = id
        self.name            = name
        self.address         = address
        self.hours           = hours
        self.spaceType       = spaceType
        self.descriptionText = descriptionText
        self.hasFood         = hasFood
        self.hasArt          = hasArt
        self.hasRestrooms    = hasRestrooms
        self.isIndoor        = isIndoor
        self.seatingInfo     = seatingInfo
        self.latitude        = latitude
        self.longitude       = longitude
    }
}
