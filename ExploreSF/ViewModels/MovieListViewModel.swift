import Foundation
import Observation

@MainActor
@Observable
final class MovieListViewModel {
    var entries:              [FilmEntry]         = []
    var searchText:           String              = ""
    var filterState:          FilterState         = FilterState()
    var actorFilteredTitles:  Set<String>?        = nil
    var isLoadingActorFilter: Bool                = false
    var posterCache:          [String: TMDBSearchResult] = [:]
    private var loadingPosters: Set<String>       = []

    var filteredEntries: [FilmEntry] {
        var result = entries
        let q = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        if !q.isEmpty {
            result = result.filter {
                $0.title.lowercased().contains(q) ||
                $0.locations.contains { $0.locationName.lowercased().contains(q) }
            }
        }
        if let hood = filterState.neighborhood {
            result = result.filter {
                $0.locations.contains { $0.locationName.lowercased().contains(hood.lowercased()) }
            }
        }
        if let year = filterState.releaseYear {
            result = result.filter { $0.releaseYear == year }
        }
        if let titles = actorFilteredTitles {
            result = result.filter { titles.contains($0.title) }
        }
        return result
    }

    var availableYears: [String] {
        Array(Set(entries.map(\.releaseYear)).filter { $0 != "Unknown" }).sorted().reversed()
    }

    var availableNeighborhoods: [String] {
        Array(Set(entries.flatMap { $0.locations.map(\.locationName) }).filter { $0 != "N/A" }).sorted()
    }

    func loadLocations(_ locations: [FilmLocation]) {
        let grouped = Dictionary(grouping: locations, by: { $0.title + $0.releaseYear })
        entries = grouped.map { _, locs in
            FilmEntry(
                id: locs[0].title + locs[0].releaseYear,
                title: locs[0].title,
                releaseYear: locs[0].releaseYear,
                locations: locs
            )
        }.sorted { $0.title < $1.title }
    }

    func fetchPosterIfNeeded(for entry: FilmEntry) async {
        guard posterCache[entry.id] == nil, !loadingPosters.contains(entry.id) else { return }
        loadingPosters.insert(entry.id)
        if let result = await TMDBService.shared.search(title: entry.title, year: entry.releaseYear) {
            posterCache[entry.id] = result
        }
        loadingPosters.remove(entry.id)
    }

    func applyActorFilter(name: String) async {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { actorFilteredTitles = nil; return }
        isLoadingActorFilter = true
        actorFilteredTitles  = await TMDBService.shared.searchActorTitles(name: trimmed)
        isLoadingActorFilter = false
    }

    func removeFilter(_ key: FilterState.FilterKey) {
        if key == .actor { actorFilteredTitles = nil }
        filterState.remove(key)
    }
}
