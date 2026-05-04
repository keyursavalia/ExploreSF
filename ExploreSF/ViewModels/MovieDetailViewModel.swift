import Foundation
import Observation

@MainActor
@Observable
final class MovieDetailViewModel {
    let entry: FilmEntry

    var searchResult: TMDBSearchResult? = nil
    var detail:       TMDBDetail?       = nil
    var credits:      TMDBCredits?      = nil
    var isLoading:    Bool              = true

    init(entry: FilmEntry) {
        self.entry = entry
    }

    func loadDetails() async {
        guard searchResult == nil else { return }
        isLoading = true

        let result = await TMDBService.shared.search(title: entry.title, year: entry.releaseYear)
        self.searchResult = result

        if let result {
            async let detailFetch  = TMDBService.shared.fetchDetail(id: result.id, isTV: result.isTV)
            async let creditsFetch = TMDBService.shared.fetchCredits(id: result.id, isTV: result.isTV)
            self.detail  = await detailFetch
            self.credits = await creditsFetch
        }

        isLoading = false
    }

    var posterURL:    URL?            { searchResult?.posterURL ?? detail?.posterURL }
    var displayTitle: String          { detail?.displayTitle ?? entry.title }
    var displayYear:  String          { detail?.displayYear.isEmpty == false ? detail!.displayYear : entry.releaseYear }
    var overview:     String?         { detail?.overview.isEmpty == false ? detail?.overview : nil }
    var director:     String?         { credits?.director }
    var topCast:      [TMDBCastMember] { credits?.topCast ?? [] }
    var genres:       String?         { let g = detail?.genreNames ?? ""; return g.isEmpty ? nil : g }
    var runtime:      String?         { detail?.displayRuntime }
    var tagline:      String?         { let t = detail?.tagline ?? ""; return t.isEmpty ? nil : t }
    var rating:       String? {
        guard let avg = detail?.voteAverage, avg > 0 else { return nil }
        return String(format: "%.1f", avg)
    }
}
