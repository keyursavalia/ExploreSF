import SwiftUI
import SwiftData

@main
struct ExploreSFApp: App {
    let sharedModelContainer: ModelContainer
    @State private var itineraryManager: ItineraryManager
    @State private var dataStore = DataStore()

    init() {
        let schema = Schema([
            SavedPlace.self,
            ItineraryPlan.self,
            ItineraryStop.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            let container = try ModelContainer(for: schema, configurations: [config])
            sharedModelContainer = container
            _itineraryManager = State(wrappedValue: ItineraryManager(context: container.mainContext))
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            AppRouterView()
                .onAppear { dataStore.load() }
                .environment(itineraryManager)
                .environment(dataStore)
        }
        .modelContainer(sharedModelContainer)
    }
}
