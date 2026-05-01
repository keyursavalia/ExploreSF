import SwiftUI

struct AppRouterView: View {
    @State private var router = AppRouter()

    var body: some View {
        @Bindable var r = router

        TabView(selection: $r.selectedTab) {
            FilmMapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(AppTab.map)

            MovieListView()
                .tabItem {
                    Label("Films", systemImage: "film.stack.fill")
                }
                .tag(AppTab.list)
        }
        .environment(router)
    }
}
