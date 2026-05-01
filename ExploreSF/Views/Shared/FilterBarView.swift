import SwiftUI

struct FilterBarView: View {
    @Binding var filterState:           FilterState
    let availableNeighborhoods:         [String]
    let availableYears:                 [String]
    let onActorSelected:                (String) async -> Void

    @State private var showNeighborhood = false
    @State private var showYear         = false
    @State private var showActor        = false

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChipView(
                    label:    filterState.neighborhood ?? "Neighborhood",
                    isActive: filterState.neighborhood != nil,
                    onTap:    { showNeighborhood = true },
                    onRemove: filterState.neighborhood != nil ? { filterState.neighborhood = nil } : nil
                )
                FilterChipView(
                    label:    filterState.releaseYear ?? "Year",
                    isActive: filterState.releaseYear != nil,
                    onTap:    { showYear = true },
                    onRemove: filterState.releaseYear != nil ? { filterState.releaseYear = nil } : nil
                )
                FilterChipView(
                    label:    filterState.actorName ?? "Actor",
                    isActive: filterState.actorName != nil,
                    onTap:    { showActor = true },
                    onRemove: filterState.actorName != nil ? { filterState.actorName = nil } : nil
                )
            }
            .padding(.horizontal, 16)
        }
        .sheet(isPresented: $showNeighborhood) {
            FilterPickerSheetView(
                title:    "Neighborhood",
                options:  availableNeighborhoods,
                selected: $filterState.neighborhood
            )
        }
        .sheet(isPresented: $showYear) {
            FilterPickerSheetView(
                title:    "Release Year",
                options:  availableYears,
                selected: $filterState.releaseYear
            )
        }
        .sheet(isPresented: $showActor) {
            ActorFilterSheetView(actorName: $filterState.actorName) { name in
                Task { await onActorSelected(name) }
            }
        }
    }
}
