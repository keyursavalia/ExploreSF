import Foundation
import SwiftData

@MainActor
func importPOPOSIfNeeded(modelContext: ModelContext) {
    let descriptor = FetchDescriptor<POPOSLocation>()
    let existingCount = (try? modelContext.fetchCount(descriptor)) ?? 0
    guard existingCount == 0 else { return }

    let features = loadPOPOSData()
    for feature in features {
        let props = feature.properties
        let location = POPOSLocation(
            id: props.remoteId,
            name: props.name,
            address: props.address ?? "",
            hours: props.hours ?? "",
            spaceType: props.type ?? "",
            descriptionText: props.description ?? "",
            hasFood: props.foodService?.lowercased() == "yes",
            hasArt: props.art?.lowercased() == "yes",
            hasRestrooms: props.restrooms != nil && props.restrooms!.lowercased() != "no",
            isIndoor: props.indoor ?? false,
            seatingInfo: props.seatingNo ?? "",
            latitude: Double(props.latitude ?? "") ?? feature.geometry.coordinates[1],
            longitude: Double(props.longitude ?? "") ?? feature.geometry.coordinates[0]
        )
        modelContext.insert(location)
    }

    try? modelContext.save()
    print("Imported \(features.count) POPOS locations to SwiftData")
}
