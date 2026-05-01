import Foundation
import SwiftData

@MainActor
func importParksIfNeeded(modelContext: ModelContext) {
    let descriptor = FetchDescriptor<ParkLocation>()
    let existingCount = (try? modelContext.fetchCount(descriptor)) ?? 0
    guard existingCount == 0 else { return }

    let features = loadParksData()
    for feature in features {
        let props = feature.properties
        guard let lat = Double(props.latitude ?? ""),
              let lon = Double(props.longitude ?? "") else { continue }

        let location = ParkLocation(
            id: props.remoteId,
            name: props.propertyName ?? "Unknown Park",
            acres: Double(props.acres ?? "0") ?? 0,
            propertyType: props.propertyType ?? "",
            address: props.address ?? "",
            neighborhood: props.neighborhood ?? "",
            complex: props.complex ?? "",
            latitude: lat,
            longitude: lon
        )
        modelContext.insert(location)
    }

    try? modelContext.save()
    print("Imported \(features.count) park locations to SwiftData")
}
