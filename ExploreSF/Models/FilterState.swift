import Foundation

struct FilterState: Equatable {
    var neighborhood: String? = nil
    var releaseYear: String? = nil
    var actorName: String? = nil

    var isActive: Bool {
        neighborhood != nil || releaseYear != nil || actorName != nil
    }

    enum FilterKey {
        case neighborhood, year, actor
    }

    mutating func remove(_ key: FilterKey) {
        switch key {
        case .neighborhood: neighborhood = nil
        case .year:         releaseYear = nil
        case .actor:        actorName = nil
        }
    }
}
