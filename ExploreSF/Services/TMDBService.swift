import Foundation

actor TMDBService {
    static let shared = TMDBService()

    private let apiKey  = Config.tmdbAPIKey
    private let baseURL = "https://api.themoviedb.org/3"

    private var searchCache:  [String: TMDBSearchResult?] = [:]
    private var detailCache:  [String: TMDBDetail]        = [:]
    private var creditsCache: [String: TMDBCredits]       = [:]

    private init() {}

    // MARK: - Multi search (movies + TV)

    func search(title: String, year: String) async -> TMDBSearchResult? {
        let key = "\(title)|\(year)"
        if let cached = searchCache[key] { return cached }

        let encoded = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? title
        let urlString = "\(baseURL)/search/multi?api_key=\(apiKey)&query=\(encoded)&year=\(year)"
        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response  = try JSONDecoder().decode(TMDBMultiSearchResponse.self, from: data)
            let result    = response.results
                .filter { $0.mediaType == "movie" || $0.mediaType == "tv" }
                .first(where: { $0.displayYear == year }) ?? response.results.first
            searchCache[key] = result
            return result
        } catch {
            searchCache[key] = nil
            return nil
        }
    }

    // MARK: - Detail

    func fetchDetail(id: Int, isTV: Bool) async -> TMDBDetail? {
        let key = "\(isTV ? "tv" : "movie")_\(id)"
        if let cached = detailCache[key] { return cached }

        let endpoint  = isTV ? "tv" : "movie"
        let urlString = "\(baseURL)/\(endpoint)/\(id)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let detail    = try JSONDecoder().decode(TMDBDetail.self, from: data)
            detailCache[key] = detail
            return detail
        } catch {
            return nil
        }
    }

    // MARK: - Credits

    func fetchCredits(id: Int, isTV: Bool) async -> TMDBCredits? {
        let key = "\(isTV ? "tv" : "movie")_\(id)"
        if let cached = creditsCache[key] { return cached }

        let endpoint  = isTV ? "tv" : "movie"
        let urlString = "\(baseURL)/\(endpoint)/\(id)/credits?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let credits   = try JSONDecoder().decode(TMDBCredits.self, from: data)
            creditsCache[key] = credits
            return credits
        } catch {
            return nil
        }
    }

    // MARK: - Actor filter

    func searchActorTitles(name: String) async -> Set<String> {
        let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        let searchURL = "\(baseURL)/search/person?api_key=\(apiKey)&query=\(encoded)"
        guard let url = URL(string: searchURL),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let response  = try? JSONDecoder().decode(TMDBPersonSearchResponse.self, from: data),
              let person    = response.results.first else { return [] }

        let creditsURL = "\(baseURL)/person/\(person.id)/combined_credits?api_key=\(apiKey)"
        guard let url2 = URL(string: creditsURL),
              let (data2, _) = try? await URLSession.shared.data(from: url2),
              let credits    = try? JSONDecoder().decode(TMDBPersonCredits.self, from: data2)
        else { return [] }

        let titles = (credits.cast + credits.crew).compactMap { $0.title ?? $0.name }
        return Set(titles)
    }
}

// MARK: - Person models (internal to service)

private struct TMDBPersonSearchResponse: Codable {
    let results: [TMDBPerson]
}

private struct TMDBPerson: Codable {
    let id: Int
    let name: String
}

private struct TMDBPersonCredits: Codable {
    let cast: [TMDBPersonCreditEntry]
    let crew: [TMDBPersonCreditEntry]
}

private struct TMDBPersonCreditEntry: Codable {
    let title: String?
    let name: String?
}
