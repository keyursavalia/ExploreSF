import SwiftUI

struct AppRouterView: View {
    @State private var router = AppRouter()

    var body: some View {
        Group {
            if !router.hasCompletedOnboarding {
                OnboardingView {
                    router.completeOnboarding()
                }
                .transition(.opacity)
            } else if router.activeCategories.isEmpty {
                CategoryPickerView(isFirstRun: true) { categories in
                    router.applyCategories(categories)
                }
                .transition(.opacity)
            } else {
                mainTabs
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: router.hasCompletedOnboarding)
        .animation(.easeInOut(duration: 0.35), value: router.activeCategories.isEmpty)
        .environment(router)
    }

    @ViewBuilder
    private var mainTabs: some View {
        @Bindable var r = router
        TabView(selection: $r.selectedTab) {
            ExploreMapView()
                .tabItem { Label("Map", systemImage: "map.fill") }
                .tag(AppTab.map)

            BrowseListView()
                .tabItem { Label("Browse", systemImage: "list.bullet") }
                .tag(AppTab.categories)

            SavedView()
                .tabItem { Label("Saved", systemImage: "bookmark.fill") }
                .tag(AppTab.saved)
        }
        .tint(router.activeTint)
    }
}
