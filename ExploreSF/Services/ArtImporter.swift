import Foundation
import SwiftData

@MainActor
func importArtIfNeeded(modelContext: ModelContext) {
    let descriptor = FetchDescriptor<ArtLocation>()
    let existingCount = (try? modelContext.fetchCount(descriptor)) ?? 0
    guard existingCount == 0 else { return }

    let features = loadArtData()
    for feature in features {
        let props = feature.properties
        let location = ArtLocation(
            id: feature.synthesizedID,
            title: props.title ?? "Untitled",
            locationName: props.name ?? "",
            artType: props.type ?? "",
            medium: props.medium ?? "",
            locationDescription: props.location ?? "",
            accessibility: props.accessibil ?? "",
            descriptionText: props.descriptio ?? "",
            artistLink: props.artistlink ?? "",
            latitude: feature.geometry.coordinates[1],
            longitude: feature.geometry.coordinates[0]
        )
        modelContext.insert(location)
    }

    try? modelContext.save()
    print("Imported \(features.count) art locations to SwiftData")
}
