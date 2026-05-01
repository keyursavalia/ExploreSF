import Foundation
import CoreLocation

func loadParkPolygons() -> [ParkPolygon] {
    loadParksData().compactMap { feature in
        let rings = feature.geometry.exteriorRings
        guard !rings.isEmpty else { return nil }
        return ParkPolygon(id: feature.properties.remoteId, rings: rings)
    }
}
