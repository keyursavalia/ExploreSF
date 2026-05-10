import SwiftUI

struct MapControlsView: View {
    @Binding var searchText:  String
    @Binding var filterState: FilterState
    let activeCategories:           Set<AppCategory>
    let availableNeighborhoods:     [String]
    let availableYears:             [String]
    let availableParkNeighborhoods: [String]
    let availableParkTypes:         [String]
    let availablePOPOSSpaceTypes:   [String]
    let availableArtTypes:                   [String]
    let availableArtMediums:                 [String]
    let availableEntertainmentLicenseTypes:  [String]
    let availableEntertainmentNeighborhoods: [String]
    let onActorSelected:                     (String) async -> Void

    @State private var showFilterSheet    = false
    @State private var showItinerarySetup = false
    @Environment(ItineraryManager.self) private var itineraryManager

    private var isFiltered:      Bool { filterState.isActive }
    private var hasActivePlan:   Bool { itineraryManager.activePlan != nil }
    private var isItineraryMode: Bool { itineraryManager.isItineraryModeActive }

    private var filterAccentColor: Color {
        activeCategories.count == 1 ? (activeCategories.first?.color ?? .appAccent) : .appAccent
    }

    var body: some View {
        HStack(spacing: 10) {
            SearchBarView(text: $searchText, placeholder: "Search…")
            itineraryButton
            filterButton
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 10)
        .sheet(isPresented: $showFilterSheet) {
            MapFilterSheetView(
                activeCategories:                    activeCategories,
                filterState:                         $filterState,
                availableNeighborhoods:              availableNeighborhoods,
                availableYears:                      availableYears,
                availableParkNeighborhoods:          availableParkNeighborhoods,
                availableParkTypes:                  availableParkTypes,
                availablePOPOSSpaceTypes:            availablePOPOSSpaceTypes,
                availableArtTypes:                   availableArtTypes,
                availableArtMediums:                 availableArtMediums,
                availableEntertainmentLicenseTypes:  availableEntertainmentLicenseTypes,
                availableEntertainmentNeighborhoods: availableEntertainmentNeighborhoods,
                onActorSelected:                     onActorSelected,
                onDismiss:                           { showFilterSheet = false }
            )
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showItinerarySetup) {
            ItinerarySetupSheet()
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Itinerary button

    private var itineraryButton: some View {
        Button {
            if hasActivePlan {
                withAnimation(.easeInOut(duration: 0.2)) {
                    itineraryManager.isItineraryModeActive.toggle()
                }
            } else {
                showItinerarySetup = true
            }
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: isItineraryMode ? "map.fill" : "map")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isItineraryMode ? Color.appPaper : Color.appInk)
                    .frame(width: 44, height: 44)
                    .background(isItineraryMode ? Color.appInk : Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(isItineraryMode ? Color.appInk : Color.appCardEdge, lineWidth: 1))
                if hasActivePlan && !isItineraryMode {
                    Circle()
                        .fill(Color.appInk)
                        .frame(width: 8, height: 8)
                        .offset(x: 2, y: -2)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isItineraryMode)
        .animation(.easeInOut(duration: 0.2), value: hasActivePlan)
    }

    // MARK: - Filter button

    private var filterButton: some View {
        Button { showFilterSheet = true } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "line.3.horizontal.decrease")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isFiltered ? filterAccentColor : Color.appInk)
                    .frame(width: 44, height: 44)
                    .background(isFiltered ? filterAccentColor.opacity(0.12) : Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appCardEdge, lineWidth: 1))
                if isFiltered {
                    Circle()
                        .fill(filterAccentColor)
                        .frame(width: 8, height: 8)
                        .offset(x: 2, y: -2)
                }
            }
        }
    }
}
