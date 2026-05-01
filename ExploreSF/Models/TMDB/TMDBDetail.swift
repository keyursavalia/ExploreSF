import Foundation

struct TMDBDetail: Codable {
    let id: Int
    let title: String?
    let name: String?
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let firstAirDate: String?
    let genres: [TMDBGenre]
    let runtime: Int?
    let episodeRunTime: [Int]?
    let voteAverage: Double
    let tagline: String?

    enum CodingKeys: String, CodingKey {
        case id, title, name, overview, genres, runtime, tagline
        case posterPath     = "poster_path"
        case releaseDate    = "release_date"
        case firstAirDate   = "first_air_date"
        case episodeRunTime = "episode_run_time"
        case voteAverage    = "vote_average"
    }

    var displayTitle: String { title ?? name ?? "Unknown" }

    var displayYear: String { String((releaseDate ?? firstAirDate ?? "").prefix(4)) }

    var displayRuntime: String? {
        if let r = runtime, r > 0 { return "\(r) min" }
        if let tv = episodeRunTime, let r = tv.first, r > 0 { return "\(r) min/ep" }
        return nil
    }

    var genreNames: String { genres.map(\.name).joined(separator: ", ") }

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}

struct TMDBGenre: Codable, Hashable {
    let id: Int
    let name: String
}
