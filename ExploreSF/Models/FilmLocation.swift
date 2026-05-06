import Foundation

struct FilmLocation: Identifiable, Hashable {
    let id: String
    let title: String
    let releaseYear: String
    let locationName: String
    let latitude: Double
    let longitude: Double
}

