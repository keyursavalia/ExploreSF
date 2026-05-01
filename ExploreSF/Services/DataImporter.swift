import Foundation
import SwiftData

@MainActor
class DataImporter {
    
    static func shared(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<MovieLocation>()
        let existingCount = (try? modelContext.fetchCount(descriptor)) ?? 0
        
        if existingCount == 0 {
            let features = loadFilmData()
            
            for feature in features {
                let location = MovieLocation(
                    id: feature.properties.remoteId,
                    title: feature.properties.title,
                    releaseYear: feature.properties.releaseYear ?? "Unknown",
                    locationName: feature.properties.locations ?? "N/A",
                    latitude: feature.geometry.coordinates[1],
                    longitude: feature.geometry.coordinates[0]
                )
                modelContext.insert(location)
            }
            
            try? modelContext.save()
            print("Imported \(features.count) locations to SwiftData")
        }
    }
}
