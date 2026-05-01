import Foundation

struct ArtFeatureCollection: Codable {
    let features: [ArtFeature]
}

struct ArtFeature: Codable {
    let geometry:   ArtGeometry
    let properties: ArtProperties
}

struct ArtGeometry: Codable {
    let coordinates: [Double]   // [longitude, latitude]
}

struct ArtProperties: Codable {
    let title:       String?
    let name:        String?    // location name (e.g. "600 California")
    let type:        String?    // e.g. "Sculpture"
    let medium:      String?    // e.g. "bronze"
    let location:    String?    // descriptive location string
    let accessibil:  String?
    let descriptio:  String?
    let artistlink:  String?
}
