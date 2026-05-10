import Foundation
import MapKit

@MainActor
@Observable
final class LookAroundSceneCache {
    static let shared = LookAroundSceneCache()
    private var cache: [String: MKLookAroundScene?] = [:]
    private var inFlight: [String: Task<MKLookAroundScene?, Never>] = [:]
    private let maxConcurrent = 3
    private init() {}

    func scene(for id: String, coordinate: CLLocationCoordinate2D) async -> MKLookAroundScene? {
        if cache.keys.contains(id) { return cache[id] ?? nil }
        if let task = inFlight[id] { return await task.value }

        // Throttle: wait until a concurrent slot is free
        while inFlight.count >= maxConcurrent {
            try? await Task.sleep(nanoseconds: 250_000_000)
        }

        // Re-check after waiting — another task may have fetched this ID
        if cache.keys.contains(id) { return cache[id] ?? nil }
        if let task = inFlight[id] { return await task.value }

        let task = Task<MKLookAroundScene?, Never> {
            try? await MKLookAroundSceneRequest(coordinate: coordinate).scene
        }
        inFlight[id] = task
        let scene = await task.value
        inFlight.removeValue(forKey: id)
        cache[id] = scene
        return scene
    }
}
