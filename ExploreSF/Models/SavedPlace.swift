import Foundation
import SwiftData

@Model
final class SavedPlace {
    @Attribute(.unique) var id: String   // "category:originalId"
    var categoryRaw: String
    var displayName: String
    var locationName: String
    var latitude: Double
    var longitude: Double
    var savedAt: Date

    var category: AppCategory? { AppCategory(rawValue: categoryRaw) }

    init(pin: PlacePin) {
        self.id           = "\(pin.category.rawValue):\(pin.id)"
        self.categoryRaw  = pin.category.rawValue
        self.displayName  = pin.displayName
        self.locationName = pin.locationName
        self.latitude     = pin.latitude
        self.longitude    = pin.longitude
        self.savedAt      = Date()
    }
}
