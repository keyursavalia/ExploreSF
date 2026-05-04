import Foundation

struct FilterState: Equatable {
    // Film
    var neighborhood: String? = nil
    var releaseYear:  String? = nil
    var actorName:    String? = nil

    // Park
    var parkNeighborhood: String? = nil
    var parkType:         String? = nil

    // POPOS
    var poposSpaceType: String? = nil
    var poposFeature:   String? = nil

    // Art
    var artType:   String? = nil
    var artMedium: String? = nil

    var isActive: Bool {
        neighborhood    != nil || releaseYear  != nil || actorName  != nil ||
        parkNeighborhood != nil || parkType    != nil ||
        poposSpaceType  != nil || poposFeature != nil ||
        artType         != nil || artMedium    != nil
    }

    enum FilterKey {
        case neighborhood, year, actor
        case parkNeighborhood, parkType
        case poposSpaceType, poposFeature
        case artType, artMedium
    }

    mutating func remove(_ key: FilterKey) {
        switch key {
        case .neighborhood:     neighborhood     = nil
        case .year:             releaseYear      = nil
        case .actor:            actorName        = nil
        case .parkNeighborhood: parkNeighborhood = nil
        case .parkType:         parkType         = nil
        case .poposSpaceType:   poposSpaceType   = nil
        case .poposFeature:     poposFeature     = nil
        case .artType:          artType          = nil
        case .artMedium:        artMedium        = nil
        }
    }
}
