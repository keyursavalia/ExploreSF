import Foundation
import CoreLocation

/// Holds the exterior ring coordinates for each polygon part of a park boundary.
/// Used to render MapPolygon overlays on the map.
struct ParkPolygon: Identifiable {
    let id: String                              // matches ParkLocation.id
    let rings: [[CLLocationCoordinate2D]]       // one ring per polygon part (exterior only)

    static func == (lhs: ParkPolygon, rhs: ParkPolygon) -> Bool { lhs.id == rhs.id }
}

extension ParkPolygon: Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
