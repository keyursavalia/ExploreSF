import Foundation

nonisolated func loadParksData() -> [ParkFeature] {
    guard let url = Bundle.main.url(forResource: "Recreation_and_Parks_Properties_20260501", withExtension: "geojson"),
          let data = try? Data(contentsOf: url) else {
        return []
    }

    do {
        let decoder = JSONDecoder()
        let response = try decoder.decode(ParkFeatureCollection.self, from: data)
        return response.features.filter {
            guard let lat = Double($0.properties.latitude ?? ""),
                  let lon = Double($0.properties.longitude ?? "") else { return false }
            return lat != 0 && lon != 0
        }
    } catch {
        print("Error parsing Parks GeoJSON: \(error)")
        return []
    }
}
