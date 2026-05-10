import Foundation

struct EntertainmentFeatureCollection: Codable {
    let features: [EntertainmentFeature]
}

struct EntertainmentFeature: Codable {
    let geometry:   EntertainmentGeometry?
    let properties: EntertainmentProperties
}

struct EntertainmentGeometry: Codable {
    let coordinates: [Double]   // [longitude, latitude]
}

struct EntertainmentProperties: Codable {
    let rowID:                String
    let permitNumber:         String?
    let ban:                  String?
    let licenseType:          String?
    let dbaName:              String?
    let streetAddress:        String?
    let analysisNeighborhood: String?
    let policeDistrict:       String?

    enum CodingKeys: String, CodingKey {
        case rowID                = ":id"
        case permitNumber         = "permit_number"
        case ban                  = "ban"
        case licenseType          = "license_type"
        case dbaName              = "dba_name"
        case streetAddress        = "street_address"
        case analysisNeighborhood = "analysis_neighborhood"
        case policeDistrict       = "police_district"
    }
}
