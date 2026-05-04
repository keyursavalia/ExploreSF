import Foundation
import CoreLocation
import Observation

@MainActor
@Observable
final class MapViewModel {
    // Raw data per category
    var filmLocations:  [FilmLocation]  = []
    var poposPlaces:    [POPOSPlace]    = []
    var parkPlaces:     [ParkPlace]     = []
    var parkPolygons:   [ParkPolygon]   = []
    var artPlaces:      [ArtPlace]      = []

    // Active categories (set by AppRouter after category picker)
    var activeCategories: Set<AppCategory> = Set(AppCategory.allCases)

    var selectedPin: PlacePin? = nil
    var pendingFlyToCoordinate: CLLocationCoordinate2D? = nil

    // Film-specific filter state (carried over from original MapViewModel)
    var searchText:           String       = ""
    var filterState:          FilterState  = FilterState()
    var actorFilteredTitles:  Set<String>? = nil
    var isLoadingActorFilter: Bool         = false

    // MARK: - Computed pins

    var visiblePins: [PlacePin] {
        var pins: [PlacePin] = []

        if activeCategories.contains(.film) {
            let filmPins = filteredFilmLocations.map { PlacePin(from: $0) }
            pins.append(contentsOf: filmPins)
        }
        if activeCategories.contains(.popos) {
            let popopsPins = poposPlaces.map { PlacePin(from: $0) }
            pins.append(contentsOf: popopsPins)
        }
        if activeCategories.contains(.park) {
            let parkPins = parkPlaces.map { PlacePin(from: $0) }
            pins.append(contentsOf: parkPins)
        }
        if activeCategories.contains(.art) {
            let artPins = artPlaces.map { PlacePin(from: $0) }
            pins.append(contentsOf: artPins)
        }
        return pins
    }

    var visiblePolygons: [ParkPolygon] {
        guard activeCategories.contains(.park) else { return [] }
        return parkPolygons
    }

    // MARK: - Film filtering

    var filteredFilmLocations: [FilmLocation] {
        var result = filmLocations
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
        Array(Set(filmLocations.map(\.releaseYear)).filter { $0 != "Unknown" }).sorted().reversed()
    }

    var availableNeighborhoods: [String] {
        Array(Set(filmLocations.map(\.locationName)).filter { $0 != "N/A" }).sorted()
    }

    // MARK: - Data loading

    func loadFilmLocations(_ locations: [FilmLocation]) {
        self.filmLocations = locations
    }

    func loadPOPOSPlaces(_ places: [POPOSPlace]) {
        self.poposPlaces = places
    }

    func loadParkPlaces(_ places: [ParkPlace], polygons: [ParkPolygon]) {
        self.parkPlaces   = places
        self.parkPolygons = polygons
    }

    func loadArtPlaces(_ places: [ArtPlace]) {
        self.artPlaces = places
    }

    // MARK: - Navigation

    func navigateTo(_ pin: PlacePin) {
        pendingFlyToCoordinate = pin.coordinate
        selectedPin = pin
    }

    func navigateToFilmLocation(_ location: FilmLocation) {
        navigateTo(PlacePin(from: location))
    }

    // MARK: - Film entry lookup (for bottom slider)

    func filmEntry(for pin: PlacePin) -> FilmEntry? {
        guard pin.category == .film,
              let location = filmLocations.first(where: { $0.id == pin.id }) else { return nil }
        let key      = location.title + location.releaseYear
        let matching = filmLocations.filter { $0.title + $0.releaseYear == key }
        return FilmEntry(
            id: key,
            title: location.title,
            releaseYear: location.releaseYear,
            locations: matching.isEmpty ? [location] : matching
        )
    }

    func poposPlace(for pin: PlacePin) -> POPOSPlace? {
        guard pin.category == .popos else { return nil }
        return poposPlaces.first { $0.id == pin.id }
    }

    func parkPlace(for pin: PlacePin) -> ParkPlace? {
        guard pin.category == .park else { return nil }
        return parkPlaces.first { $0.id == pin.id }
    }

    func artPlace(for pin: PlacePin) -> ArtPlace? {
        guard pin.category == .art else { return nil }
        return artPlaces.first { $0.id == pin.id }
    }

    // MARK: - Actor filter

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

    func resetFilters() {
        searchText          = ""
        filterState         = FilterState()
        actorFilteredTitles = nil
    }
}
