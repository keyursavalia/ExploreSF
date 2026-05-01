import Foundation
import Observation

@MainActor
@Observable
final class BrowseListViewModel {
    var filmLocations: [FilmLocation]  = []
    var poposPlaces:   [POPOSPlace]    = []
    var parkPlaces:    [ParkPlace]     = []

    var activeCategories: Set<AppCategory> = Set(AppCategory.allCases)
    var searchText: String = ""
    var isFilterSheetPresented: Bool = false

    // MARK: - Filtered results

    var filteredFilm: [FilmLocation] {
        guard activeCategories.contains(.film) else { return [] }
        guard !searchText.isEmpty else { return filmLocations }
        let q = searchText.lowercased()
        return filmLocations.filter {
            $0.title.lowercased().contains(q) || $0.locationName.lowercased().contains(q)
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

    var totalCount: Int { filteredFilm.count + filteredPOPOS.count + filteredParks.count }

    // MARK: - Loading

    func loadFilm(_ locations: [FilmLocation]) { filmLocations = locations }
    func loadPOPOS(_ places: [POPOSPlace]) { poposPlaces = places }
    func loadParks(_ places: [ParkPlace]) { parkPlaces = places }
}
