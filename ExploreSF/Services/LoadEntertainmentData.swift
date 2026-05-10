import Foundation

nonisolated func loadEntertainmentData() -> [EntertainmentFeature] {
    guard let url = Bundle.main.url(forResource: "Active_Entertainment_Permits_20260510", withExtension: "geojson"),
          let data = try? Data(contentsOf: url),
          let collection = try? JSONDecoder().decode(EntertainmentFeatureCollection.self, from: data)
    else { return [] }
    return collection.features
}
