import Foundation

struct FilmProperties: Codable {
    let remoteId: String
    let title: String
    let releaseYear: String?
    let locations: String?
    
    enum CodingKeys: String, CodingKey {
        case remoteId = ":id"
        case title
        case releaseYear = "release_year"
        case locations
    }
}
