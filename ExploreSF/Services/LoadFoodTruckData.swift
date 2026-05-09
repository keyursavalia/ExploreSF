import Foundation

nonisolated func loadFoodTruckData() -> [FoodTruckFeature] {
    guard let url = Bundle.main.url(
        forResource: "Mobile_Food_Facility_Permit_20260508",
        withExtension: "geojson"
    ),
    let data = try? Data(contentsOf: url) else { return [] }

    do {
        let response = try JSONDecoder().decode(FoodTruckFeatureCollection.self, from: data)
        return response.features.filter {
            $0.geometry.coordinates.count == 2 &&
            $0.properties.descriptio == "Status: APPROVED"
        }
    } catch {
        return []
    }
}
