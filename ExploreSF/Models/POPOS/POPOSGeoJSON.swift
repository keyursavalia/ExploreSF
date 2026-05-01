import Foundation

struct POPOSFeatureCollection: Codable {
    let features: [POPOSFeature]
}

struct POPOSFeature: Codable {
    let geometry:   POPOSGeometry
    let properties: POPOSProperties
}

struct POPOSGeometry: Codable {
    let coordinates: [Double]   // [longitude, latitude]
}

struct POPOSProperties: Codable {
    let remoteId:    String
    let name:        String
    let address:     String?
    let hours:       String?
    let type:        String?
    let description: String?
    let foodService: String?
    let art:         String?
    let restrooms:   String?
    let indoor:      Bool?
    let seatingNo:   String?
    let latitude:    String?
    let longitude:   String?

    enum CodingKeys: String, CodingKey {
        case remoteId    = ":id"
        case name
        case address     = "popos_address"
        case hours
        case type
        case description
        case foodService = "food_service"
        case art
        case restrooms
        case indoor
        case seatingNo   = "seating_no"
        case latitude
        case longitude
    }
}
