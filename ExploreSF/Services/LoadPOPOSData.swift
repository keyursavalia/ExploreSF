import Foundation

func loadPOPOSData() -> [POPOSFeature] {
    guard let url = Bundle.main.url(forResource: "Privately_Owned_Public_Open_Spaces_20260501", withExtension: "geojson"),
          let data = try? Data(contentsOf: url) else {
        return []
    }

    do {
        let decoder = JSONDecoder()
        let response = try decoder.decode(POPOSFeatureCollection.self, from: data)
        return response.features.filter { $0.geometry.coordinates.count == 2 }
    } catch {
        print("Error parsing POPOS GeoJSON: \(error)")
        return []
    }
}
