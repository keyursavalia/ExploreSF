import Foundation
import SwiftData

@Model
final class ArtLocation {
    @Attribute(.unique) var id: String
    var title: String
    var locationName: String
    var artType: String
    var medium: String
    var locationDescription: String
    var accessibility: String
    var descriptionText: String
    var artistLink: String
    var latitude: Double
    var longitude: Double

    init(
        id: String, title: String, locationName: String, artType: String,
        medium: String, locationDescription: String, accessibility: String,
        descriptionText: String, artistLink: String,
        latitude: Double, longitude: Double
    ) {
        self.id                  = id
        self.title               = title
        self.locationName        = locationName
        self.artType             = artType
        self.medium              = medium
        self.locationDescription = locationDescription
        self.accessibility       = accessibility
        self.descriptionText     = descriptionText
        self.artistLink          = artistLink
        self.latitude            = latitude
        self.longitude           = longitude
    }
}
