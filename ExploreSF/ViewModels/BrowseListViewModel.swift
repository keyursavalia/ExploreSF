import Foundation
import Observation

@MainActor
@Observable
final class BrowseListViewModel {
    var filmEntries:   [FilmEntry]     = []
    var poposPlaces:   [POPOSPlace]    = []
    var parkPlaces:    [ParkPlace]     = []
    var artPlaces:     [ArtPlace]      = []

    var activeCategories: Set<AppCategory> = Set(AppCategory.allCases)
    var searchText: String = ""

    var posterCache: [String: TMDBSearchResult] = [:]
    private var loadingPosters: Set<String> = []

    // MARK: - Filtered results

    var filteredFilm: [FilmEntry] {
        guard activeCategories.contains(.film) else { return [] }
        guard !searchText.isEmpty else { return filmEntries }
        let q = searchText.lowercased()
        return filmEntries.filter {
            $0.title.lowercased().contains(q) ||
            $0.locations.contains { $0.locationName.lowercased().contains(q) }
        }
    }

    var filteredPOPOS: [POPOSPlace] {
        guard activeCategories.contains(.popos) else { return [] }
        guard !searchText.isEmpty else { return poposPlaces }
        let q = searchText.lowercased()
        return poposPlaces.filter {
            $0.name.lowercased().contains(q) || $0.address.lowercased().contains(q)
        }
    }

    var filteredParks: [ParkPlace] {
        guard activeCategories.contains(.park) else { return [] }
        guard !searchText.isEmpty else { return parkPlaces }
        let q = searchText.lowercased()
        return parkPlaces.filter {
            $0.name.lowercased().contains(q) || $0.neighborhood.lowercased().contains(q)
        }
    }

    var filteredArt: [ArtPlace] {
        guard activeCategories.contains(.art) else { return [] }
        guard !searchText.isEmpty else { return artPlaces }
        let q = searchText.lowercased()
        return artPlaces.filter {
            $0.title.lowercased().contains(q) || $0.locationName.lowercased().contains(q)
        }
    }

    var totalCount: Int {
        filteredFilm.count + filteredPOPOS.count + filteredParks.count + filteredArt.count
    }

    // MARK: - Loading

    func loadFilm(_ locations: [FilmLocation]) {
        Task {
            let entries = await Task.detached(priority: .userInitiated) {
                let grouped = Dictionary(grouping: locations, by: { $0.title + $0.releaseYear })
                return grouped.map { _, locs in
                    FilmEntry(
                        id: locs[0].title + locs[0].releaseYear,
                        title: locs[0].title,
                        releaseYear: locs[0].releaseYear,
                        locations: locs
                    )
                }.sorted { $0.title < $1.title }
            }.value
            filmEntries = entries
        }
    }

    func loadPOPOS(_ places: [POPOSPlace]) { poposPlaces = places }
    func loadParks(_ places: [ParkPlace])  { parkPlaces = places }
    func loadArt(_ places: [ArtPlace])     { artPlaces = places }

    // MARK: - Poster fetching

    func fetchPosterIfNeeded(for entry: FilmEntry) async {
        guard posterCache[entry.id] == nil, !loadingPosters.contains(entry.id) else { return }
        loadingPosters.insert(entry.id)
        if let result = await TMDBService.shared.search(title: entry.title, year: entry.releaseYear) {
            posterCache[entry.id] = result
        }
        loadingPosters.remove(entry.id)
    }
}
