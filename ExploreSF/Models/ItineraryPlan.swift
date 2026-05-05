import Foundation
import SwiftData

@Model
final class ItineraryPlan {
    @Attribute(.unique) var id: String
    var createdAt: Date
    var totalDays: Int
    @Relationship(deleteRule: .cascade, inverse: \ItineraryStop.plan) var stops: [ItineraryStop] = []

    init(totalDays: Int) {
        self.id        = UUID().uuidString
        self.createdAt = Date()
        self.totalDays = totalDays
    }

    func orderedStops(for day: Int) -> [ItineraryStop] {
        stops.filter { $0.dayNumber == day }
             .sorted { $0.orderInDay < $1.orderInDay }
    }

    var completedCount: Int { stops.filter(\.isCompleted).count }
    var progress: Double { stops.isEmpty ? 0 : Double(completedCount) / Double(stops.count) }
}
