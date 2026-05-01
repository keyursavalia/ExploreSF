import Foundation

struct TMDBCredits: Codable {
    let cast: [TMDBCastMember]
    let crew: [TMDBCrewMember]

    var director: String? {
        crew.first(where: { $0.job == "Director" })?.name
    }

    var topCast: [TMDBCastMember] { Array(cast.prefix(5)) }
}

struct TMDBCastMember: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }
}

struct TMDBCrewMember: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let job: String
}
