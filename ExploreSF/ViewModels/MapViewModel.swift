import Foundation
import CoreLocation
import MapKit
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

    // Utility overlay data (not categories)
    var bathroomPlaces:      [BathroomPlace]      = []
    var waterFountainPlaces: [WaterFountainPlace]  = []
    var foodTruckPlaces:     [FoodTruckPlace]      = []

    // Utility overlay toggle state
    var showBathrooms:      Bool = false
    var showWaterFountains: Bool = false
    var showFoodTrucks:     Bool = false

    // Utility overlay selection (for info sheets)
    var selectedBathroom:      BathroomPlace?      = nil
    var selectedWaterFountain: WaterFountainPlace?  = nil
    var selectedFoodTruck:     FoodTruckPlace?      = nil

    // Active categories (set by AppRouter after category picker)
    var activeCategories: Set<AppCategory> = Set(AppCategory.allCases)

    var selectedPin: PlacePin? = nil
    var pendingFlyToCoordinate: CLLocationCoordinate2D? = nil
    var visibleRegion: MKCoordinateRegion? = nil

    // Film-specific filter state (carried over from original MapViewModel)
    var searchText:           String       = ""
    var filterState:          FilterState  = FilterState()
    var actorFilteredTitles:  Set<String>? = nil
    var isLoadingActorFilter: Bool         = false

    // MARK: - Computed pins

    var visiblePins: [PlacePin] {
        var pins: [PlacePin] = []
        if activeCategories.contains(.film)  { pins.append(contentsOf: filteredFilmLocations.map  { PlacePin(from: $0) }) }
        if activeCategories.contains(.popos) { pins.append(contentsOf: filteredPOPOSPlaces.map    { PlacePin(from: $0) }) }
        if activeCategories.contains(.park)  { pins.append(contentsOf: filteredParkPlaces.map     { PlacePin(from: $0) }) }
        if activeCategories.contains(.art)   { pins.append(contentsOf: filteredArtPlaces.map      { PlacePin(from: $0) }) }
        guard let region = visibleRegion else { return pins }
        return pins.filter { region.contains($0.coordinate) }
    }

    var visiblePolygons: [ParkPolygon] {
        guard activeCategories.contains(.park) else { return [] }
        let visibleIDs = Set(filteredParkPlaces.map(\.id))
        let filtered = parkPolygons.filter { visibleIDs.contains($0.id) }
        guard let region = visibleRegion else { return filtered }
        return filtered.filter { polygon in
            polygon.rings.contains { ring in ring.contains { region.contains($0) } }
        }
    }

    // MARK: - Utility overlay visible arrays

    var visibleBathrooms: [BathroomPlace] {
        guard showBathrooms else { return [] }
        guard let region = visibleRegion else { return bathroomPlaces }
        return bathroomPlaces.filter { region.contains($0.coordinate) }
    }

    var visibleWaterFountains: [WaterFountainPlace] {
        guard showWaterFountains else { return [] }
        guard let region = visibleRegion else { return waterFountainPlaces }
        return waterFountainPlaces.filter { region.contains($0.coordinate) }
    }

    var visibleFoodTrucks: [FoodTruckPlace] {
        guard showFoodTrucks else { return [] }
        guard let region = visibleRegion else { return foodTruckPlaces }
        return foodTruckPlaces.filter { region.contains($0.coordinate) }
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

    // MARK: - POPOS filtering

    var filteredPOPOSPlaces: [POPOSPlace] {
        var result = poposPlaces
        let q = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        if !q.isEmpty {
            result = result.filter {
                $0.name.lowercased().contains(q) || $0.address.lowercased().contains(q)
            }
        }
        if let type = filterState.poposSpaceType {
            result = result.filter { $0.spaceType == type }
        }
        if let feature = filterState.poposFeature {
            result = result.filter { place in
                switch feature {
                case "Indoor":    return place.isIndoor
                case "Food":      return place.hasFood
                case "Art":       return place.hasArt
                case "Restrooms": return place.hasRestrooms
                default:          return true
                }
            }
        }
        return result
    }

    // MARK: - Park filtering

    var filteredParkPlaces: [ParkPlace] {
        var result = parkPlaces
        let q = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        if !q.isEmpty {
            result = result.filter {
                $0.name.lowercased().contains(q) || $0.address.lowercased().contains(q)
            }
        }
        if let hood = filterState.parkNeighborhood {
            result = result.filter { $0.neighborhood == hood }
        }
        if let type = filterState.parkType {
            result = result.filter { $0.propertyType == type }
        }
        return result
    }

    // MARK: - Art filtering

    var filteredArtPlaces: [ArtPlace] {
        var result = artPlaces
        let q = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        if !q.isEmpty {
            result = result.filter {
                $0.title.lowercased().contains(q) || $0.locationName.lowercased().contains(q)
            }
        }
        if let type = filterState.artType {
            result = result.filter { $0.artType == type }
        }
        if let medium = filterState.artMedium {
            result = result.filter { $0.medium == medium }
        }
        return result
    }

    // MARK: - Available filter values (Film)

    var availableYears: [String] {
        Array(Set(filmLocations.map(\.releaseYear)).filter { $0 != "Unknown" }).sorted().reversed()
    }

    var availableNeighborhoods: [String] {
        Array(Set(filmLocations.map(\.locationName)).filter { $0 != "N/A" }).sorted()
    }

    // MARK: - Available filter values (Park)

    var availableParkNeighborhoods: [String] {
        Array(Set(parkPlaces.map(\.neighborhood)).filter { !$0.isEmpty }).sorted()
    }

    var availableParkTypes: [String] {
        Array(Set(parkPlaces.map(\.propertyType)).filter { !$0.isEmpty }).sorted()
    }

    // MARK: - Available filter values (POPOS)

    var availablePOPOSSpaceTypes: [String] {
        Array(Set(poposPlaces.map(\.spaceType)).filter { !$0.isEmpty }).sorted()
    }

    // MARK: - Available filter values (Art)

    var availableArtTypes: [String] {
        Array(Set(artPlaces.map(\.artType)).filter { !$0.isEmpty }).sorted()
    }

    var availableArtMediums: [String] {
        Array(Set(artPlaces.map(\.medium)).filter { !$0.isEmpty }).sorted()
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

    func loadBathroomPlaces(_ places: [BathroomPlace]) {
        self.bathroomPlaces = places
    }

    func loadWaterFountainPlaces(_ places: [WaterFountainPlace]) {
        self.waterFountainPlaces = places
    }

    func loadFoodTruckPlaces(_ places: [FoodTruckPlace]) {
        self.foodTruckPlaces = places
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

private extension MKCoordinateRegion {
    func contains(_ coordinate: CLLocationCoordinate2D, buffer: Double = 1.2) -> Bool {
        let halfLat = span.latitudeDelta  * 0.5 * buffer
        let halfLon = span.longitudeDelta * 0.5 * buffer
        return abs(coordinate.latitude  - center.latitude)  <= halfLat
            && abs(coordinate.longitude - center.longitude) <= halfLon
    }
}
