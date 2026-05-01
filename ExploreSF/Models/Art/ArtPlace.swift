import Foundation

struct ArtPlace: Identifiable, Hashable {
    let id: String
    let title: String
    let locationName: String
    let artType: String
    let medium: String
    let locationDescription: String
    let accessibility: String
    let descriptionText: String
    let artistLink: String
    let latitude: Double
    let longitude: Double
}

extension ArtPlace {
    init(from model: ArtLocation) {
        self.id                  = model.id
        self.title               = model.title
        self.locationName        = model.locationName
        self.artType             = model.artType
        self.medium              = model.medium
        self.locationDescription = model.locationDescription
        self.accessibility       = model.accessibility
        self.descriptionText     = model.descriptionText
        self.artistLink          = model.artistLink
        self.latitude            = model.latitude
        self.longitude           = model.longitude
    }
}
