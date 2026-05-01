import Foundation

struct FilmLocation: Identifiable, Hashable {
    let id: String
    let title: String
    let releaseYear: String
    let locationName: String
    let latitude: Double
    let longitude: Double
}

extension FilmLocation {
    init(from model: MovieLocation) {
        self.id = model.id
        self.title = model.title
        self.releaseYear = model.releaseYear
        self.locationName = model.locationName
        self.latitude = model.latitude
        self.longitude = model.longitude
    }
}
