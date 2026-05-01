import Foundation

func loadFilmData() -> [Feature] {
    guard let url = Bundle.main.url(forResource: "Film_Locations_in_San_Francisco_20260430", withExtension: "geojson"),
            let data = try? Data(contentsOf: url) else {
        return []
    }
    
    do {
        let decoder = JSONDecoder()
        let response = try decoder.decode(FilmLocationResponse.self, from: data)
        return response.features.filter { $0.geometry.coordinates.count == 2 }
    } catch {
        print("Error parsing GeoJSON: \(error)")
        return []
    }
}
