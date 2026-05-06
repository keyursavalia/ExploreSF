import Foundation

nonisolated func loadArtData() -> [ArtFeature] {
    guard let url = Bundle.main.url(forResource: "Public_Art_20240313", withExtension: "geojson"),
          let data = try? Data(contentsOf: url) else {
        return []
    }

    do {
        let decoder = JSONDecoder()
        let response = try decoder.decode(ArtFeatureCollection.self, from: data)
        return response.features.filter { ($0.geometry?.coordinates.count ?? 0) == 2 }
    } catch {
        print("Error parsing Public Art GeoJSON: \(error)")
        return []
    }
}

private func synthesizeID(from title: String?) -> String {
    let base = (title ?? "unknown")
        .lowercased()
        .components(separatedBy: .alphanumerics.inverted)
        .filter { !$0.isEmpty }
        .joined(separator: "_")
    return String(base.prefix(60))
}

extension ArtFeature {
    nonisolated var synthesizedID: String {
        let base = (properties.title ?? "unknown")
            .lowercased()
            .components(separatedBy: .alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: "_")
        return String(base.prefix(60))
    }
}
