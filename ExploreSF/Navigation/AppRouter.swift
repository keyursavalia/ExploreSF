import Foundation
import Observation
import SwiftUI

enum AppTab: Int {
    case map        = 0
    case categories = 1
    case saved      = 2
}

@MainActor
@Observable
final class AppRouter {
    var hasCompletedOnboarding: Bool = false
    var activeCategories: Set<AppCategory> = []
    var selectedTab: AppTab = .map
    var pendingPin: PlacePin? = nil

    var isReadyForMap: Bool {
        hasCompletedOnboarding && !activeCategories.isEmpty
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
    }

    func applyCategories(_ categories: Set<AppCategory>) {
        activeCategories = categories
    }

    func navigateTo(pin: PlacePin) {
        pendingPin   = pin
        selectedTab  = .map
    }

    var activeTint: Color {
        activeCategories.count == 1
            ? (activeCategories.first?.color ?? Color.appInk)
            : Color.appInk
    }
}
