import Foundation

nonisolated func loadBathroomsData() -> [PublicFacilityFeature] {
    guard let url = Bundle.main.url(
        forResource: "San_Francisco_Public_Bathrooms_20260507",
        withExtension: "geojson"
    ),
    let data = try? Data(contentsOf: url) else { return [] }

    do {
        let response = try JSONDecoder().decode(PublicFacilityFeatureCollection.self, from: data)
        return response.features.filter { $0.geometry.coordinates.count == 2 }
    } catch {
        return []
    }
}
