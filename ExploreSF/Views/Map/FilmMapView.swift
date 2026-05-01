import SwiftUI
import MapKit
import SwiftData

struct FilmMapView: View {
    @Query(sort: \MovieLocation.title) private var allLocations: [MovieLocation]
    @State  private var viewModel = MapViewModel()
    @State  private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span:   MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var vm = viewModel

        ZStack(alignment: .top) {
            Map(position: $cameraPosition, selection: $vm.selectedLocation) {
                ForEach(viewModel.filteredLocations) { location in
                    Marker(location.title, coordinate: CLLocationCoordinate2D(
                        latitude:  location.latitude,
                        longitude: location.longitude
                    ))
                    .tag(location)
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea()

            MapControlsView(
                searchText:             $vm.searchText,
                filterState:            $vm.filterState,
                availableNeighborhoods: viewModel.availableNeighborhoods,
                availableYears:         viewModel.availableYears,
                onActorSelected:        { name in await viewModel.applyActorFilter(name: name) }
            )
        }
        .sheet(item: $vm.selectedLocation) { location in
            MapPinSliderView(
                selectedLocation: location,
                filmEntry:        viewModel.filmEntry(for: location)
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .onChange(of: allLocations, initial: true) { _, new in
            viewModel.loadLocations(new.map(FilmLocation.init))
        }
        .onChange(of: router.pendingLocation) { _, pending in
            guard let location = pending else { return }
            viewModel.navigateTo(location)
            router.pendingLocation = nil
        }
        .onChange(of: viewModel.pendingFlyToCoordinate) { _, coordinate in
            guard let coordinate else { return }
            withAnimation {
                cameraPosition = .camera(MapCamera(
                    centerCoordinate: coordinate,
                    distance: 800
                ))
            }
            viewModel.pendingFlyToCoordinate = nil
        }
    }
}
