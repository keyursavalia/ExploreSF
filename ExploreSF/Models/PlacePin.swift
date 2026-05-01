import Foundation
import CoreLocation

/// Lightweight map-pin value type shared across all categories.
/// Views use PlacePin for Map(selection:) binding; full detail is fetched by the ViewModel.
struct PlacePin: Identifiable, Hashable {
    let id: String
    let category: AppCategory
    let displayName: String
    let locationName: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension PlacePin {
    init(from film: FilmLocation) {
        self.id           = film.id
        self.category     = .film
        self.displayName  = film.title
        self.locationName = film.locationName
        self.latitude     = film.latitude
        self.longitude    = film.longitude
    }

    init(from popos: POPOSPlace) {
        self.id           = popos.id
        self.category     = .popos
        self.displayName  = popos.name
        self.locationName = popos.address
        self.latitude     = popos.latitude
        self.longitude    = popos.longitude
    }

    init(from park: ParkPlace) {
        self.id           = park.id
        self.category     = .park
        self.displayName  = park.name
        self.locationName = park.address
        self.latitude     = park.latitude
        self.longitude    = park.longitude
    }
}
