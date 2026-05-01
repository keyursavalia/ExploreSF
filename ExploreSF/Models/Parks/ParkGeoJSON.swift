import Foundation
import CoreLocation

struct ParkFeatureCollection: Codable {
    let features: [ParkFeature]
}

struct ParkFeature: Codable {
    let geometry:   ParkGeometry
    let properties: ParkProperties
}

/// MultiPolygon: [polygon][ring][coordinate] where coordinate is [longitude, latitude].
struct ParkGeometry: Codable {
    let coordinates: [[[[Double]]]]

    /// Extracts the exterior ring of each polygon part, dropping holes.
    var exteriorRings: [[CLLocationCoordinate2D]] {
        coordinates.compactMap { polygon in
            guard let exterior = polygon.first else { return nil }
            return exterior.compactMap { coord in
                guard coord.count >= 2 else { return nil }
                return CLLocationCoordinate2D(latitude: coord[1], longitude: coord[0])
            }
        }
    }
}

struct ParkProperties: Codable {
    let remoteId:     String
    let propertyName: String?
    let acres:        String?
    let propertyType: String?
    let address:      String?
    let neighborhood: String?
    let complex:      String?
    let latitude:     String?
    let longitude:    String?

    enum CodingKeys: String, CodingKey {
        case remoteId     = ":id"
        case propertyName = "property_name"
        case acres
        case propertyType = "propertytype"
        case address
        case neighborhood = "analysis_neighborhood"
        case complex
        case latitude
        case longitude
    }
}
