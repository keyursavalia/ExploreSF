import Foundation

struct FoodTruckFeatureCollection: Codable {
    let features: [FoodTruckFeature]
}

struct FoodTruckFeature: Codable {
    let geometry:   FoodTruckGeometry
    let properties: FoodTruckProperties
}

struct FoodTruckGeometry: Codable {
    let coordinates: [Double]   // [longitude, latitude]
}

struct FoodTruckProperties: Codable {
    let name:       String?   // operator/vendor name
    let title:      String?   // food items sold
    let type:       String?   // "Truck" | "Push Cart" | "Information not provided"
    let location:   String?   // street address / location description
    let requiredar: String?   // "Permit: XXMFF-XXXXX"
    let descriptio: String?   // "Status: APPROVED" | "Status: REQUESTED" | "Status: EXPIRED" | ...
}
