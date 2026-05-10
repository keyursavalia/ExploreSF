import Foundation
import MapKit
import Observation

@MainActor
@Observable
final class EntertainmentDetailViewModel {
    let place: EntertainmentPlace

    var lookAroundScene:       MKLookAroundScene? = nil
    var isLookAroundAvailable: Bool = false

    init(place: EntertainmentPlace) {
        self.place = place
    }

    func loadData() async {
        let request       = MKLookAroundSceneRequest(coordinate: place.coordinate)
        lookAroundScene       = try? await request.scene
        isLookAroundAvailable = lookAroundScene != nil
    }

    func openInMaps() {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
        item.name = place.name
        item.openInMaps()
    }
}
