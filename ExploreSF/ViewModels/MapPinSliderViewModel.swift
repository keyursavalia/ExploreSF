import Foundation
import MapKit
import Observation

@MainActor
@Observable
final class MapPinSliderViewModel {
    let pin: PlacePin

    // Film-specific
    var filmSearchResult:        TMDBSearchResult? = nil
    var lookAroundScene:         MKLookAroundScene? = nil
    var isLookAroundAvailable:   Bool = false
    var isLoadingTMDB:           Bool = false

    init(pin: PlacePin) {
        self.pin = pin
    }

    func loadData() async {
        switch pin.category {
        case .film:
            await withTaskGroup(of: Void.self) { group in
                group.addTask { await self.fetchTMDB() }
                group.addTask { await self.checkLookAround() }
            }
        case .popos, .park:
            await checkLookAround()
        }
    }

    private func fetchTMDB() async {
        isLoadingTMDB   = true
        filmSearchResult = await TMDBService.shared.search(
            title: pin.displayName,
            year: ""
        )
        isLoadingTMDB   = false
    }

    private func checkLookAround() async {
        let request    = MKLookAroundSceneRequest(coordinate: pin.coordinate)
        lookAroundScene       = try? await request.scene
        isLookAroundAvailable = lookAroundScene != nil
    }

    func openInMaps() {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: pin.coordinate))
        item.name = pin.locationName
        item.openInMaps()
    }
}
