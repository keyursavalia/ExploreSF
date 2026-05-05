import Foundation
import CoreLocation
import SwiftData
import Observation

@MainActor
@Observable
final class ItineraryManager {
    private let context: ModelContext

    var activePlan: ItineraryPlan? = nil
    var isItineraryModeActive: Bool = false
    var selectedDay: Int = 1

    init(context: ModelContext) {
        self.context = context
        loadActivePlan()
    }

    // MARK: - Load

    func loadActivePlan() {
        let descriptor = FetchDescriptor<ItineraryPlan>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        activePlan = try? context.fetch(descriptor).first
        if let plan = activePlan {
            selectedDay = min(selectedDay, plan.totalDays)
        }
    }

    // MARK: - Generate

    func generatePlan(from places: [SavedPlace], stopsLimit: Int?, days: Int, startLocation: CLLocation) {
        if let existing = activePlan {
            context.delete(existing)
        }

        let candidates = stopsLimit.map { Array(places.prefix($0)) } ?? places
        guard !candidates.isEmpty else { return }

        let ordered    = nearestNeighbor(from: startLocation, candidates: candidates)
        let totalCount = ordered.count
        let plan       = ItineraryPlan(totalDays: days)
        context.insert(plan)

        var dayCounters: [Int: Int] = [:]
        for (globalIndex, place) in ordered.enumerated() {
            let dayNumber  = days > 1 ? (globalIndex * days / totalCount) + 1 : 1
            let orderInDay = dayCounters[dayNumber, default: 0]
            dayCounters[dayNumber] = orderInDay + 1

            let stop = ItineraryStop(from: place, dayNumber: dayNumber, orderInDay: orderInDay)
            stop.plan = plan
            context.insert(stop)
        }

        try? context.save()
        activePlan            = plan
        selectedDay           = 1
        isItineraryModeActive = true
    }

    // MARK: - Completion

    func toggleComplete(_ stop: ItineraryStop) {
        stop.isCompleted = !stop.isCompleted
        stop.completedAt = stop.isCompleted ? Date() : nil
        try? context.save()
    }

    // MARK: - Delete

    func deletePlan() {
        guard let plan = activePlan else { return }
        context.delete(plan)
        try? context.save()
        activePlan            = nil
        isItineraryModeActive = false
        selectedDay           = 1
    }

    // MARK: - Nearest Neighbor Algorithm

    private func nearestNeighbor(from start: CLLocation, candidates: [SavedPlace]) -> [SavedPlace] {
        var remaining = candidates
        var ordered: [SavedPlace] = []
        var current = start

        while !remaining.isEmpty {
            guard let nearest = remaining.min(by: {
                CLLocation(latitude: $0.latitude, longitude: $0.longitude).distance(from: current) <
                CLLocation(latitude: $1.latitude, longitude: $1.longitude).distance(from: current)
            }) else { break }
            ordered.append(nearest)
            remaining.removeAll { $0.id == nearest.id }
            current = CLLocation(latitude: nearest.latitude, longitude: nearest.longitude)
        }

        return ordered
    }
}
