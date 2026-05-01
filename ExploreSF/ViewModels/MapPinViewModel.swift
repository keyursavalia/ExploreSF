import Foundation
import MapKit
import Observation

@MainActor
@Observable
final class MapPinViewModel {
    let location: FilmLocation

    var searchResult:        TMDBSearchResult? = nil
    var lookAroundScene:     MKLookAroundScene? = nil
    var isLookAroundAvailable: Bool            = false
    var isLoadingTMDB:       Bool              = false

    init(location: FilmLocation) {
        self.location = location
    }

    func loadData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchTMDB() }
            group.addTask { await self.checkLookAround() }
        }
    }

    private func fetchTMDB() async {
        isLoadingTMDB = true
        searchResult  = await TMDBService.shared.search(title: location.title, year: location.releaseYear)
        isLoadingTMDB = false
    }

    private func checkLookAround() async {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let request    = MKLookAroundSceneRequest(coordinate: coordinate)
        lookAroundScene       = try? await request.scene
        isLookAroundAvailable = lookAroundScene != nil
    }

    func openInMaps() {
        let coordinate  = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        destination.name = location.locationName
        destination.openInMaps()
    }
}
