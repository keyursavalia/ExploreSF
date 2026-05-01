import Foundation
import SwiftData

@Model
final class MovieLocation {
    @Attribute(.unique) var id: String
    var title: String
    var releaseYear: String
    var locationName: String
    var latitude: Double
    var longitude: Double
    
    init(id: String, title: String, releaseYear: String, locationName: String, latitude: Double, longitude: Double) {
        self.id = id
        self.title = title
        self.releaseYear = releaseYear
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
    }
}
