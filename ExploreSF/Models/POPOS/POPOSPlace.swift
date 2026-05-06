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

