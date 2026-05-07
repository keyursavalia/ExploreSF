import Foundation

nonisolated func loadWaterFountainsData() -> [PublicFacilityFeature] {
    guard let url = Bundle.main.url(
        forResource: "San_Francisco_Public_Water_Fountains_20260507",
        withExtension: "geojson"
    ),
    let data = try? Data(contentsOf: url) else { return [] }

    do {
        let response = try JSONDecoder().decode(PublicFacilityFeatureCollection.self, from: data)
        // Filter out non-SF entries (e.g. Camp Mather) by requiring a known SF neighborhood
        return response.features.filter {
            $0.geometry.coordinates.count == 2 && $0.properties.analysisNeighborhood != nil
        }
    } catch {
        return []
    }
}
