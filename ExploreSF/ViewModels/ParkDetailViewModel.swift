import Foundation
import MapKit
import Observation

@MainActor
@Observable
final class ParkDetailViewModel {
    let place: ParkPlace
    var polygon: ParkPolygon? = nil

    var lookAroundScene:       MKLookAroundScene? = nil
    var isLookAroundAvailable: Bool = false

    init(place: ParkPlace, polygon: ParkPolygon? = nil) {
        self.place   = place
        self.polygon = polygon
    }

    func loadData() async {
        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        let request    = MKLookAroundSceneRequest(coordinate: coordinate)
        lookAroundScene       = try? await request.scene
        isLookAroundAvailable = lookAroundScene != nil
    }

    func openInMaps() {
        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        let item = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        item.name = place.name
        item.openInMaps()
    }
}
