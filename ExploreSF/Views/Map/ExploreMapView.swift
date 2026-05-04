import SwiftUI
import MapKit
import SwiftData

struct ExploreMapView: View {
    @Query(sort: \MovieLocation.title)  private var allFilm:  [MovieLocation]
    @Query(sort: \POPOSLocation.name)   private var allPOPOS: [POPOSLocation]
    @Query(sort: \ParkLocation.name)    private var allParks: [ParkLocation]
    @Query(sort: \ArtLocation.title)    private var allArt:   [ArtLocation]

    @State private var viewModel = MapViewModel()
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span:   MKCoordinateSpan(latitudeDelta: 0.12, longitudeDelta: 0.12)
        )
    )
    @State private var showCategoryPopover = false

    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var vm = viewModel

        ZStack(alignment: .top) {
            Map(position: $cameraPosition, selection: $vm.selectedPin) {
                ForEach(viewModel.visiblePins) { pin in
                    pinMarker(for: pin)
                }
                ForEach(viewModel.visiblePolygons) { polygon in
                    ForEach(Array(polygon.rings.enumerated()), id: \.offset) { _, ring in
                        MapPolygon(coordinates: ring)
                            .foregroundStyle(AppCategory.park.color.opacity(0.18))
                            .stroke(AppCategory.park.color.opacity(0.5), lineWidth: 1.5)
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea()

            MapControlsView(
                searchText:             $vm.searchText,
                filterState:            $vm.filterState,
                activeCategories:       router.activeCategories,
                availableNeighborhoods: viewModel.availableNeighborhoods,
                availableYears:         viewModel.availableYears,
                onActorSelected:        { name in await viewModel.applyActorFilter(name: name) }
            )

            // Floating category toggle — bottom of map, above tab bar
            VStack {
                Spacer()
                CategoryToggleBar(
                    activeCategories: router.activeCategories,
                    isExpanded: $showCategoryPopover,
                    onApply: { cats in
                        router.applyCategories(cats)
                        showCategoryPopover = false
                    }
                )
                .padding(.bottom, 90)
            }
        }
        .sheet(item: $vm.selectedPin) { pin in
            MapPinSliderView(pin: pin, mapViewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: allFilm, initial: true) { _, new in
            viewModel.loadFilmLocations(new.map(FilmLocation.init))
        }
        .onChange(of: allPOPOS, initial: true) { _, new in
            viewModel.loadPOPOSPlaces(new.map(POPOSPlace.init))
        }
        .onChange(of: allParks, initial: true) { _, new in
            viewModel.loadParkPlaces(new.map(ParkPlace.init), polygons: loadParkPolygons())
        }
        .onChange(of: allArt, initial: true) { _, new in
            viewModel.loadArtPlaces(new.map(ArtPlace.init))
        }
        .onChange(of: router.activeCategories, initial: true) { old, cats in
            viewModel.activeCategories = cats
            if old != cats { viewModel.resetFilters() }
        }
        .onChange(of: router.pendingPin) { _, pending in
            guard let pin = pending else { return }
            viewModel.navigateTo(pin)
            router.pendingPin = nil
        }
        .onChange(of: viewModel.pendingFlyToCoordinate) { _, coordinate in
            guard let coordinate else { return }
            withAnimation {
                cameraPosition = .camera(MapCamera(centerCoordinate: coordinate, distance: 800))
            }
            viewModel.pendingFlyToCoordinate = nil
        }
    }

    @MapContentBuilder
    private func pinMarker(for pin: PlacePin) -> some MapContent {
        switch pin.category {
        case .film:
            Marker(pin.displayName, systemImage: "film", coordinate: pin.coordinate)
                .tint(AppCategory.film.color)
                .tag(pin)
        case .popos:
            Marker(pin.displayName, systemImage: "building.columns", coordinate: pin.coordinate)
                .tint(AppCategory.popos.color)
                .tag(pin)
        case .park:
            Marker(pin.displayName, systemImage: "tree", coordinate: pin.coordinate)
                .tint(AppCategory.park.color)
                .tag(pin)
        case .art:
            Marker(pin.displayName, systemImage: "photo.artframe", coordinate: pin.coordinate)
                .tint(AppCategory.art.color)
                .tag(pin)
        }
    }
}
