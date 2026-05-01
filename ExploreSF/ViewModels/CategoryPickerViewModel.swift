import Foundation
import Observation

@MainActor
@Observable
final class CategoryPickerViewModel {
    var selected: Set<AppCategory> = []

    var canContinue: Bool { !selected.isEmpty }

    func toggle(_ category: AppCategory) {
        if selected.contains(category) {
            selected.remove(category)
        } else {
            selected.insert(category)
        }
    }

    func isSelected(_ category: AppCategory) -> Bool {
        selected.contains(category)
    }
}
