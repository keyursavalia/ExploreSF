import Foundation
import Observation

enum AppTab: Int {
    case map  = 0
    case list = 1
}

@MainActor
@Observable
final class AppRouter {
    var selectedTab: AppTab = .map
    var pendingLocation: FilmLocation? = nil

    func navigate(to location: FilmLocation) {
        pendingLocation = location
        selectedTab     = .map
    }
}
