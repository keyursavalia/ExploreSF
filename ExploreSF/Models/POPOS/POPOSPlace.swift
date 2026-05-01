import Foundation

/// Value type representation of a Privately Owned Public Open Space.
struct POPOSPlace: Identifiable, Hashable {
    let id: String
    let name: String
    let address: String
    let hours: String
    let spaceType: String
    let descriptionText: String
    let hasFood: Bool
    let hasArt: Bool
    let hasRestrooms: Bool
    let isIndoor: Bool
    let seatingInfo: String
    let latitude: Double
    let longitude: Double
}

extension POPOSPlace {
    init(from model: POPOSLocation) {
        self.id              = model.id
        self.name            = model.name
        self.address         = model.address
        self.hours           = model.hours
        self.spaceType       = model.spaceType
        self.descriptionText = model.descriptionText
        self.hasFood         = model.hasFood
        self.hasArt          = model.hasArt
        self.hasRestrooms    = model.hasRestrooms
        self.isIndoor        = model.isIndoor
        self.seatingInfo     = model.seatingInfo
        self.latitude        = model.latitude
        self.longitude       = model.longitude
    }
}
