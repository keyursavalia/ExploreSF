import SwiftUI

struct MapControlsView: View {
    @Binding var searchText:  String
    @Binding var filterState: FilterState
    let availableNeighborhoods: [String]
    let availableYears:         [String]
    let onActorSelected:        (String) async -> Void

    var body: some View {
        VStack(spacing: 8) {
            SearchBarView(text: $searchText, placeholder: "Search films, locations...")
                .padding(.horizontal, 16)

            FilterBarView(
                filterState:            $filterState,
                availableNeighborhoods: availableNeighborhoods,
                availableYears:         availableYears,
                onActorSelected:        onActorSelected
            )
        }
        .padding(.top, 56)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
    }
}
