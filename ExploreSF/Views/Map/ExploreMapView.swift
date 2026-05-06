import SwiftUI
import MapKit

struct ExploreMapView: View {
    @Environment(DataStore.self)        private var dataStore
    @Environment(AppRouter.self)        private var router
    @Environment(ItineraryManager.self) private var itineraryManager

    @State private var viewModel = MapViewModel()
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span:   MKCoordinateSpan(latitudeDelta: 0.12, longitudeDelta: 0.12)
        )
    )
    @State private var showCategoryPopover = false

    var body: some View {
        @Bindable var vm = viewModel

        ZStack(alignment: .top) {
            Map(position: $cameraPosition, selection: $vm.selectedPin) {
                if itineraryManager.isItineraryModeActive, let plan = itineraryManager.activePlan {
                    itineraryMapContent(plan: plan)
                } else {
                    normalMapContent
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea()

            MapControlsView(
                searchText:                 $vm.searchText,
                filterState:                $vm.filterState,
                activeCategories:           router.activeCategories,
                availableNeighborhoods:     viewModel.availableNeighborhoods,
                availableYears:             viewModel.availableYears,
                availableParkNeighborhoods: viewModel.availableParkNeighborhoods,
                availableParkTypes:         viewModel.availableParkTypes,
                availablePOPOSSpaceTypes:   viewModel.availablePOPOSSpaceTypes,
                availableArtTypes:          viewModel.availableArtTypes,
                availableArtMediums:        viewModel.availableArtMediums,
                onActorSelected:            { name in await viewModel.applyActorFilter(name: name) }
            )

            VStack {
                Spacer()
                if itineraryManager.isItineraryModeActive,
                   let plan = itineraryManager.activePlan,
                   plan.totalDays > 1 {
                    itineraryDayBar(plan: plan)
                        .padding(.bottom, 100)
                } else if !itineraryManager.isItineraryModeActive {
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
        }
        .sheet(item: $vm.selectedPin) { pin in
            MapPinSliderView(pin: pin, mapViewModel: viewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: dataStore.filmLocations, initial: true) { _, new in
            viewModel.loadFilmLocations(new)
        }
        .onChange(of: dataStore.poposPlaces, initial: true) { _, new in
            viewModel.loadPOPOSPlaces(new)
        }
        .onChange(of: dataStore.parkPlaces, initial: true) { _, new in
            viewModel.loadParkPlaces(new, polygons: dataStore.parkPolygons)
        }
        .onChange(of: dataStore.artPlaces, initial: true) { _, new in
            viewModel.loadArtPlaces(new)
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
        .onMapCameraChange(frequency: .onEnd) { context in
            viewModel.visibleRegion = context.region
        }
    }

    // MARK: - Normal map content

    @MapContentBuilder
    private var normalMapContent: some MapContent {
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

    // MARK: - Itinerary map content

    @MapContentBuilder
    private func itineraryMapContent(plan: ItineraryPlan) -> some MapContent {
        let dayStops = plan.orderedStops(for: itineraryManager.selectedDay)
        let coords   = dayStops.map(\.coordinate)

        if coords.count > 1 {
            MapPolyline(coordinates: coords)
                .stroke(Color.appInk.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
        }

        ForEach(dayStops, id: \.id) { stop in
            Annotation(stop.displayName, coordinate: stop.coordinate, anchor: .bottom) {
                ItineraryAnnotationView(
                    number:      stop.orderInDay + 1,
                    category:    stop.category ?? .film,
                    isCompleted: stop.isCompleted
                )
            }
            .tag(stop.asPlacePin)
        }
    }

    // MARK: - Itinerary day bar

    private func itineraryDayBar(plan: ItineraryPlan) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<plan.totalDays) { index in
                    ItineraryDayPill(
                        day: index + 1,
                        isActive: itineraryManager.selectedDay == index + 1,
                        onSelect: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                itineraryManager.selectedDay = index + 1
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Normal pin marker

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
