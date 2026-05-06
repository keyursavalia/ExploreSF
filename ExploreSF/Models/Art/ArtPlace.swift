import Foundation

struct ArtPlace: Identifiable, Hashable {
    let id: String
    let title: String
    let locationName: String
    let artType: String
    let medium: String
    let locationDescription: String
    let accessibility: String
    let descriptionText: String
    let artistLink: String
    let latitude: Double
    let longitude: Double
}

