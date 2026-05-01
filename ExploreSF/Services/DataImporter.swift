import Foundation
import SwiftData

@MainActor
class DataImporter {

    static func shared(modelContext: ModelContext) {
        importFilmLocationsIfNeeded(modelContext: modelContext)
        importPOPOSIfNeeded(modelContext: modelContext)
        importParksIfNeeded(modelContext: modelContext)
    }

    private static func importFilmLocationsIfNeeded(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<MovieLocation>()
        let existingCount = (try? modelContext.fetchCount(descriptor)) ?? 0
        guard existingCount == 0 else { return }

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
        print("Imported \(features.count) film locations to SwiftData")
    }
}
