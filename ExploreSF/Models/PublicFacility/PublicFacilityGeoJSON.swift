import Foundation

struct PublicFacilityFeatureCollection: Codable {
    let features: [PublicFacilityFeature]
}

struct PublicFacilityFeature: Codable {
    let geometry: PublicFacilityGeometry
    let properties: PublicFacilityProperties
}

struct PublicFacilityGeometry: Codable {
    let coordinates: [Double]
}

struct PublicFacilityProperties: Codable {
    let uid: String
    let name: String
    let address: String?
    let latitude: String?
    let longitude: String?
    let publicAccessHoursOpen: String?
    let publicAccessHoursClose: String?
    let publicAccessDays: String?
    let access: String?
    let park: String?
    let notes: String?
    let bottleFiller: String?
    let dogFountain: String?
    let analysisNeighborhood: String?

    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case address
        case latitude
        case longitude
        case publicAccessHoursOpen  = "public_access_hours_open"
        case publicAccessHoursClose = "public_access_hours_close"
        case publicAccessDays       = "public_access_days"
        case access
        case park
        case notes
        case bottleFiller           = "bottle_filler"
        case dogFountain            = "dog_fountain"
        case analysisNeighborhood   = "analysis_neighborhood"
    }
}
