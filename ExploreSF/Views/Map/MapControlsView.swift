import SwiftUI

struct MapControlsView: View {
    @Binding var searchText:  String
    @Binding var filterState: FilterState
    let activeCategories:       Set<AppCategory>
    let availableNeighborhoods: [String]
    let availableYears:         [String]
    let onActorSelected:        (String) async -> Void

    @State private var showFilterSheet = false

    private var isFiltered: Bool { filterState.isActive }

    var body: some View {
        HStack(spacing: 10) {
            SearchBarView(text: $searchText, placeholder: "Search…")

            Button { showFilterSheet = true } label: {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(isFiltered ? Color.appAccent : Color.appInk)
                        .frame(width: 44, height: 44)
                        .background(isFiltered ? Color.appAccentSoft : Color.appCard)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appCardEdge, lineWidth: 1))
                    if isFiltered {
                        Circle()
                            .fill(Color.appAccent)
                            .frame(width: 8, height: 8)
                            .offset(x: 2, y: -2)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 56)
        .padding(.bottom, 10)
        .background(.ultraThinMaterial)
        .sheet(isPresented: $showFilterSheet) {
            MapFilterSheetView(
                activeCategories:       activeCategories,
                filterState:            $filterState,
                availableNeighborhoods: availableNeighborhoods,
                availableYears:         availableYears,
                onActorSelected:        onActorSelected,
                onDismiss:              { showFilterSheet = false }
            )
            .presentationDetents([.medium, .large])
        }
    }
}
