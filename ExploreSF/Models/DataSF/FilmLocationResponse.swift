import Foundation

struct FilmLocationResponse: Codable {
    let features: [Feature]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var featuresContainer = try container.nestedUnkeyedContainer(forKey: .features)
        var validFeatures: [Feature] = []
        var skipCount: Int = 0
        
        while !featuresContainer.isAtEnd {
            do {
                let feature = try featuresContainer.decode(Feature.self)
                validFeatures.append(feature)
            } catch {
                skipCount += 1
                _ = try? featuresContainer.decode(EmptyCodable.self)
            }
        }
        print("Skipped \(skipCount) rows due to missing data")
        self.features = validFeatures
    }
    
    enum CodingKeys: String, CodingKey { case features }
}

struct EmptyCodable: Codable {}
