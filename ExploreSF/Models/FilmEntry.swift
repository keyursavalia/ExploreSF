import Foundation

struct FilmEntry: Identifiable, Hashable {
    let id: String
    let title: String
    let releaseYear: String
    let locations: [FilmLocation]
}
