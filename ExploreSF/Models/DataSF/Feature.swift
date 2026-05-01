import Foundation

struct Feature: Codable {
    let geometry: Geometry
    let properties: FilmProperties
    
    enum CodingKeys: String, CodingKey {
        case geometry, properties
    }
}
