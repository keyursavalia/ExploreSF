import Foundation
import MapKit
import UIKit

@MainActor
@Observable
final class MapSnapshotService {
    static let shared = MapSnapshotService()
    private var cache: [String: UIImage] = [:]
    private init() {}

    func snapshot(id: String, coordinate: CLLocationCoordinate2D, size: CGSize) async -> UIImage? {
        if let cached = cache[id] { return cached }

        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
        )
        options.size = size
        options.mapType = .mutedStandard
        options.showsBuildings = true
        options.showsPointsOfInterest = false

        let snapshotter = MKMapSnapshotter(options: options)
        let image = await withCheckedContinuation { (continuation: CheckedContinuation<UIImage?, Never>) in
            snapshotter.start { snapshot, _ in
                continuation.resume(returning: snapshot?.image)
            }
        }
        if let image { cache[id] = image }
        return image
    }
}
