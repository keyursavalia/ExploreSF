import Foundation
import Observation

@MainActor
@Observable
final class OnboardingViewModel {
    var currentPage: Int = 0

    let totalPages = 3

    var isLastPage: Bool { currentPage == totalPages - 1 }

    func advance() {
        if currentPage < totalPages - 1 {
            currentPage += 1
        }
    }
}
