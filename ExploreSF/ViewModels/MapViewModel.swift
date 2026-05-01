import Foundation
import CoreLocation
import Observation

@MainActor
@Observable
final class MapViewModel {
    var locations:            [FilmLocation]      = []
    var searchText:           String              = ""
    var filterState:          FilterState         = FilterState()
    var actorFilteredTitles:  Set<String>?        = nil
    var isLoadingActorFilter: Bool                = false
    var selectedLocation:     FilmLocation?       = nil

    // Emitted when the map should fly to a coordinate (nil after consumed by the view)
    var pendingFlyToCoordinate: CLLocationCoordinate2D? = nil

    var filteredLocations: [FilmLocation] {
        var result = locations
        let q = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        if !q.isEmpty {
            result = result.filter {
                $0.title.lowercased().contains(q) ||
                $0.locationName.lowercased().contains(q)
            }
        }
        if let hood = filterState.neighborhood {
            result = result.filter { $0.locationName.lowercased().contains(hood.lowercased()) }
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
        Array(Set(locations.map(\.releaseYear)).filter { $0 != "Unknown" }).sorted().reversed()
    }

    var availableNeighborhoods: [String] {
        Array(Set(locations.map(\.locationName)).filter { $0 != "N/A" }).sorted()
    }

    func loadLocations(_ locations: [FilmLocation]) {
        self.locations = locations
    }

    func filmEntry(for location: FilmLocation) -> FilmEntry {
        let key      = location.title + location.releaseYear
        let matching = filteredLocations.filter { $0.title + $0.releaseYear == key }
        return FilmEntry(
            id: key,
            title: location.title,
            releaseYear: location.releaseYear,
            locations: matching.isEmpty ? [location] : matching
        )
    }

    func navigateTo(_ location: FilmLocation) {
        pendingFlyToCoordinate = CLLocationCoordinate2D(
            latitude:  location.latitude,
            longitude: location.longitude
        )
        selectedLocation = location
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
