import Foundation
import CoreLocation
import SwiftData

@Model
final class ItineraryStop {
    @Attribute(.unique) var id: String
    var plan: ItineraryPlan?
    var savedPlaceID: String       // composite "category:originalId" from SavedPlace
    var displayName: String
    var locationName: String
    var latitude: Double
    var longitude: Double
    var categoryRaw: String
    var dayNumber: Int             // 1-indexed
    var orderInDay: Int            // 0-indexed within the day
    var isCompleted: Bool
    var completedAt: Date?

    var category: AppCategory? { AppCategory(rawValue: categoryRaw) }
    var coordinate: CLLocationCoordinate2D { CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
    var clLocation: CLLocation { CLLocation(latitude: latitude, longitude: longitude) }

    var asPlacePin: PlacePin {
        let parts = savedPlaceID.split(separator: ":", maxSplits: 1)
        let originalID = parts.count > 1 ? String(parts[1]) : savedPlaceID
        return PlacePin(
            id: originalID,
            category: category ?? .film,
            displayName: displayName,
            locationName: locationName,
            latitude: latitude,
            longitude: longitude
        )
    }

    init(from place: SavedPlace, dayNumber: Int, orderInDay: Int) {
        self.id           = UUID().uuidString
        self.savedPlaceID = place.id
        self.displayName  = place.displayName
        self.locationName = place.locationName
        self.latitude     = place.latitude
        self.longitude    = place.longitude
        self.categoryRaw  = place.categoryRaw
        self.dayNumber    = dayNumber
        self.orderInDay   = orderInDay
        self.isCompleted  = false
    }
}
