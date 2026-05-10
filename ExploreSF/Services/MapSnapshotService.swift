import Foundation
import MapKit
import UIKit

enum MapSnapshotStyle {
    case parkSatellite
    case streetHybrid

    var mapType: MKMapType {
        switch self {
        case .parkSatellite: return .satellite
        case .streetHybrid:  return .hybrid
        }
    }

    var span: MKCoordinateSpan {
        switch self {
        case .parkSatellite: return MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        case .streetHybrid:  return MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        }
    }
}

@MainActor
@Observable
final class MapSnapshotService {
    static let shared = MapSnapshotService()
    private var cache: [String: UIImage] = [:]
    private init() {}

    func snapshot(id: String, coordinate: CLLocationCoordinate2D, style: MapSnapshotStyle, size: CGSize) async -> UIImage? {
        if let cached = cache[id] { return cached }

        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(center: coordinate, span: style.span)
        options.size = size
        options.mapType = style.mapType
        options.showsBuildings = true

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
