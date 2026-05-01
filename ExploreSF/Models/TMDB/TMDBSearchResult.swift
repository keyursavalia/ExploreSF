import Foundation

struct TMDBMultiSearchResponse: Codable {
    let results: [TMDBSearchResult]
}

struct TMDBSearchResult: Codable, Identifiable, Hashable {
    let id: Int
    let mediaType: String?
    let title: String?
    let name: String?
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let firstAirDate: String?

    enum CodingKeys: String, CodingKey {
        case id, title, name, overview
        case mediaType    = "media_type"
        case posterPath   = "poster_path"
        case releaseDate  = "release_date"
        case firstAirDate = "first_air_date"
    }

    var displayTitle: String { title ?? name ?? "Unknown" }

    var displayYear: String { String((releaseDate ?? firstAirDate ?? "").prefix(4)) }

    var isTV: Bool { mediaType == "tv" }

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
