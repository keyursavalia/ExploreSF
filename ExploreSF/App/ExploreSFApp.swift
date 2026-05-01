import SwiftUI
import SwiftData

@main
struct ExploreSFApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([MovieLocation.self, POPOSLocation.self, ParkLocation.self, ArtLocation.self, SavedPlace.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppRouterView()
                .onAppear {
                    DataImporter.shared(modelContext: sharedModelContainer.mainContext)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
