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
    private enum Keys {
        static let onboardingDone = "hasCompletedOnboarding"
        static let activeCategories = "activeCategories"
    }

    var hasCompletedOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasCompletedOnboarding, forKey: Keys.onboardingDone) }
    }
    var activeCategories: Set<AppCategory> {
        didSet {
            let raw = activeCategories.map(\.rawValue)
            UserDefaults.standard.set(raw, forKey: Keys.activeCategories)
        }
    }
    var selectedTab: AppTab = .map
    var pendingPin: PlacePin? = nil

    init() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: Keys.onboardingDone)
        let saved = UserDefaults.standard.stringArray(forKey: Keys.activeCategories) ?? []
        activeCategories = Set(saved.compactMap(AppCategory.init(rawValue:)))
    }

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
