import SwiftUI

struct MapFilterSheetView: View {
    let activeCategories:       Set<AppCategory>
    @Binding var filterState:   FilterState
    let availableNeighborhoods: [String]
    let availableYears:         [String]
    let onActorSelected:        (String) async -> Void
    let onDismiss:              () -> Void

    @State private var showNeighborhood = false
    @State private var showYear         = false
    @State private var showActor        = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    if activeCategories.contains(.film)  { filmSection }
                    if activeCategories.contains(.park)  { noFilterSection(.park) }
                    if activeCategories.contains(.popos) { noFilterSection(.popos) }
                    if activeCategories.contains(.art)   { noFilterSection(.art) }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
            .background(Color.appPaper)
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { onDismiss() }
                        .foregroundStyle(Color.appInk)
                }
                if filterState.isActive {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Clear All") { filterState = FilterState() }
                            .foregroundStyle(AppCategory.film.color)
                    }
                }
            }
        }
        .sheet(isPresented: $showYear) {
            FilterPickerSheetView(
                title: "Release Year", options: availableYears, selected: $filterState.releaseYear
            )
        }
        .sheet(isPresented: $showNeighborhood) {
            FilterPickerSheetView(
                title: "Neighborhood", options: availableNeighborhoods, selected: $filterState.neighborhood
            )
        }
        .sheet(isPresented: $showActor) {
            ActorFilterSheetView(actorName: $filterState.actorName) { name in
                Task { await onActorSelected(name) }
            }
        }
    }

    // MARK: Film section

    private var filmSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(.film)
            filterRow(title: "Year",         value: filterState.releaseYear,  onTap: { showYear = true },         onClear: { filterState.releaseYear  = nil })
            filterRow(title: "Neighborhood", value: filterState.neighborhood, onTap: { showNeighborhood = true }, onClear: { filterState.neighborhood = nil })
            filterRow(title: "Actor",        value: filterState.actorName,    onTap: { showActor = true },        onClear: { filterState.actorName    = nil })
        }
    }

    private func noFilterSection(_ category: AppCategory) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(category)
            Text("Use the search bar to find \(category.displayName.lowercased()) by name.")
                .font(.appBody)
                .foregroundStyle(Color.appInk3)
                .padding(.horizontal, 4)
        }
    }

    // MARK: Helpers

    private func sectionHeader(_ category: AppCategory) -> some View {
        HStack(spacing: 6) {
            Circle().fill(category.color).frame(width: 8, height: 8)
            Text(category.displayName)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.appInk)
        }
    }

    private func filterRow(title: String, value: String?, onTap: @escaping () -> Void, onClear: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.appInk)
                Spacer()
                if let value {
                    Text(value)
                        .font(.system(size: 14))
                        .foregroundStyle(AppCategory.film.color)
                        .lineLimit(1)
                    Button(action: onClear) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.appInk4)
                            .font(.system(size: 16))
                    }
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.appInk4)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appCardEdge, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}
