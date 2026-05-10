import Foundation
import Observation

@MainActor
@Observable
final class DataStore {
    var filmLocations:        [FilmLocation]        = []
    var poposPlaces:          [POPOSPlace]          = []
    var parkPlaces:           [ParkPlace]           = []
    var parkPolygons:         [ParkPolygon]         = []
    var artPlaces:            [ArtPlace]            = []
    var entertainmentPlaces:  [EntertainmentPlace]  = []
    var bathroomPlaces:       [BathroomPlace]       = []
    var waterFountainPlaces:  [WaterFountainPlace]  = []
    var foodTruckPlaces:      [FoodTruckPlace]      = []

    func load() {
        Task {
            let result = await Task.detached(priority: .userInitiated) {
                DataStore.parseAll()
            }.value
            filmLocations        = result.film
            poposPlaces          = result.popos
            parkPlaces           = result.parks
            parkPolygons         = result.polygons
            artPlaces            = result.art
            entertainmentPlaces  = result.entertainment
            bathroomPlaces       = result.bathrooms
            waterFountainPlaces  = result.waterFountains
            foodTruckPlaces      = result.foodTrucks
        }
    }

    private nonisolated static func parseAll() -> (
        film: [FilmLocation], popos: [POPOSPlace],
        parks: [ParkPlace], polygons: [ParkPolygon], art: [ArtPlace],
        entertainment: [EntertainmentPlace],
        bathrooms: [BathroomPlace], waterFountains: [WaterFountainPlace],
        foodTrucks: [FoodTruckPlace]
    ) {
        let (parks, polygons) = parseParks()
        return (parseFilm(), parsePOPOS(), parks, polygons, parseArt(), parseEntertainment(), parseBathrooms(), parseWaterFountains(), parseFoodTrucks())
    }

    private nonisolated static func parseFilm() -> [FilmLocation] {
        loadFilmData().map { feature in
            FilmLocation(
                id: feature.properties.remoteId,
                title: feature.properties.title,
                releaseYear: feature.properties.releaseYear ?? "Unknown",
                locationName: feature.properties.locations ?? "N/A",
                latitude: feature.geometry.coordinates[1],
                longitude: feature.geometry.coordinates[0]
            )
        }
    }

    private nonisolated static func parsePOPOS() -> [POPOSPlace] {
        loadPOPOSData().map { feature in
            let p = feature.properties
            return POPOSPlace(
                id: p.remoteId,
                name: p.name,
                address: p.address ?? "",
                hours: p.hours ?? "",
                spaceType: p.type ?? "",
                descriptionText: p.description ?? "",
                hasFood: p.foodService?.lowercased() == "yes",
                hasArt: p.art?.lowercased() == "yes",
                hasRestrooms: p.restrooms != nil && p.restrooms!.lowercased() != "no",
                isIndoor: p.indoor ?? false,
                seatingInfo: p.seatingNo ?? "",
                latitude: Double(p.latitude ?? "") ?? feature.geometry.coordinates[1],
                longitude: Double(p.longitude ?? "") ?? feature.geometry.coordinates[0]
            )
        }
    }

    private nonisolated static func parseParks() -> ([ParkPlace], [ParkPolygon]) {
        var places:   [ParkPlace]   = []
        var polygons: [ParkPolygon] = []
        for feature in loadParksData() {
            let p = feature.properties
            guard let lat = Double(p.latitude ?? ""),
                  let lon = Double(p.longitude ?? "") else { continue }
            places.append(ParkPlace(
                id: p.remoteId,
                name: p.propertyName ?? "Unknown Park",
                acres: Double(p.acres ?? "0") ?? 0,
                propertyType: p.propertyType ?? "",
                address: p.address ?? "",
                neighborhood: p.neighborhood ?? "",
                complex: p.complex ?? "",
                latitude: lat,
                longitude: lon
            ))
            let rings = feature.geometry.exteriorRings
            if !rings.isEmpty {
                polygons.append(ParkPolygon(id: p.remoteId, rings: rings))
            }
        }
        return (places, polygons)
    }

    private nonisolated static func parseArt() -> [ArtPlace] {
        loadArtData().compactMap { feature in
            guard let geo = feature.geometry, geo.coordinates.count == 2 else { return nil }
            let p = feature.properties
            return ArtPlace(
                id: feature.synthesizedID,
                title: p.title ?? "Untitled",
                locationName: p.name ?? "",
                artType: p.type ?? "",
                medium: p.medium ?? "",
                locationDescription: p.location ?? "",
                accessibility: p.accessibil ?? "",
                descriptionText: p.descriptio ?? "",
                artistLink: p.artistlink ?? "",
                latitude: geo.coordinates[1],
                longitude: geo.coordinates[0]
            )
        }
    }

    private nonisolated static func parseEntertainment() -> [EntertainmentPlace] {
        loadEntertainmentData().compactMap { feature in
            guard let geo = feature.geometry, geo.coordinates.count == 2 else { return nil }
            let p = feature.properties
            return EntertainmentPlace(
                id:           p.rowID,
                name:         p.dbaName ?? "Unknown Venue",
                address:      p.streetAddress ?? "",
                licenseType:  EntertainmentPlace.simplifiedLicenseType(p.licenseType ?? ""),
                neighborhood: p.analysisNeighborhood ?? "",
                latitude:     geo.coordinates[1],
                longitude:    geo.coordinates[0]
            )
        }
    }

    private nonisolated static func parseBathrooms() -> [BathroomPlace] {
        loadBathroomsData().map { feature in
            let p = feature.properties
            let lat = Double(p.latitude ?? "") ?? feature.geometry.coordinates[1]
            let lon = Double(p.longitude ?? "") ?? feature.geometry.coordinates[0]
            return BathroomPlace(
                id: p.uid,
                name: p.name,
                address: p.address ?? "",
                hoursOpen: p.publicAccessHoursOpen,
                hoursClose: p.publicAccessHoursClose,
                accessDays: p.publicAccessDays ?? "Daily",
                isPublicAccess: p.access == "publicly_accessible",
                park: p.park,
                notes: p.notes,
                latitude: lat,
                longitude: lon
            )
        }
    }

    private nonisolated static func parseWaterFountains() -> [WaterFountainPlace] {
        loadWaterFountainsData().map { feature in
            let p = feature.properties
            let lat = Double(p.latitude ?? "") ?? feature.geometry.coordinates[1]
            let lon = Double(p.longitude ?? "") ?? feature.geometry.coordinates[0]
            return WaterFountainPlace(
                id: p.uid,
                name: p.name,
                address: p.address ?? "",
                hoursOpen: p.publicAccessHoursOpen,
                hoursClose: p.publicAccessHoursClose,
                accessDays: p.publicAccessDays ?? "Daily",
                isPublicAccess: p.access == "publicly_accessible",
                park: p.park,
                notes: p.notes,
                hasBottleFiller: p.bottleFiller == "1",
                hasDogFountain: p.dogFountain == "1",
                latitude: lat,
                longitude: lon
            )
        }
    }

    private nonisolated static func parseFoodTrucks() -> [FoodTruckPlace] {
        loadFoodTruckData().map { feature in
            let p = feature.properties
            let lat = feature.geometry.coordinates[1]
            let lon = feature.geometry.coordinates[0]
            let permit = p.requiredar.flatMap {
                $0.hasPrefix("Permit: ") ? String($0.dropFirst(8)) : $0
            } ?? ""
            let id = "\(permit)_\(String(format: "%.5f", lat))_\(String(format: "%.5f", lon))"
            return FoodTruckPlace(
                id: id,
                name: p.name ?? "Unknown Vendor",
                foodItems: p.title ?? "",
                facilityType: FoodTruckPlace.FacilityType(raw: p.type),
                locationDescription: p.location ?? "",
                permitNumber: permit,
                latitude: lat,
                longitude: lon
            )
        }
    }
}
