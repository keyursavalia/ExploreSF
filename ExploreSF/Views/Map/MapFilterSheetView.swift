import SwiftUI

struct MapFilterSheetView: View {
    let activeCategories:           Set<AppCategory>
    @Binding var filterState:       FilterState
    let availableNeighborhoods:     [String]
    let availableYears:             [String]
    let availableParkNeighborhoods: [String]
    let availableParkTypes:         [String]
    let availablePOPOSSpaceTypes:   [String]
    let availableArtTypes:          [String]
    let availableArtMediums:        [String]
    let onActorSelected:            (String) async -> Void
    let onDismiss:                  () -> Void

    @State private var showNeighborhood     = false
    @State private var showYear             = false
    @State private var showActor            = false
    @State private var showParkNeighborhood = false
    @State private var showParkType         = false
    @State private var showPOPOSSpaceType   = false
    @State private var showPOPOSFeature     = false
    @State private var showArtType          = false
    @State private var showArtMedium        = false

    private static let poposFeatures = ["Indoor", "Food", "Art", "Restrooms"]

    private var categoryAccentColor: Color {
        activeCategories.count == 1 ? (activeCategories.first?.color ?? .appAccent) : .appAccent
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    if activeCategories.contains(.film)  { filmSection }
                    if activeCategories.contains(.park)  { parkSection }
                    if activeCategories.contains(.popos) { poposSection }
                    if activeCategories.contains(.art)   { artSection }
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
                            .foregroundStyle(categoryAccentColor)
                    }
                }
            }
        }
        .sheet(isPresented: $showYear) {
            FilterPickerSheetView(title: "Release Year", options: availableYears,           selected: $filterState.releaseYear)
        }
        .sheet(isPresented: $showNeighborhood) {
            FilterPickerSheetView(title: "Neighborhood",  options: availableNeighborhoods,  selected: $filterState.neighborhood)
        }
        .sheet(isPresented: $showActor) {
            ActorFilterSheetView(actorName: $filterState.actorName) { name in
                Task { await onActorSelected(name) }
            }
        }
        .sheet(isPresented: $showParkNeighborhood) {
            FilterPickerSheetView(title: "Neighborhood", options: availableParkNeighborhoods, selected: $filterState.parkNeighborhood)
        }
        .sheet(isPresented: $showParkType) {
            FilterPickerSheetView(title: "Park Type",   options: availableParkTypes,         selected: $filterState.parkType)
        }
        .sheet(isPresented: $showPOPOSSpaceType) {
            FilterPickerSheetView(title: "Space Type",  options: availablePOPOSSpaceTypes,   selected: $filterState.poposSpaceType)
        }
        .sheet(isPresented: $showPOPOSFeature) {
            FilterPickerSheetView(title: "Feature",     options: Self.poposFeatures,         selected: $filterState.poposFeature)
        }
        .sheet(isPresented: $showArtType) {
            FilterPickerSheetView(title: "Art Type",    options: availableArtTypes,          selected: $filterState.artType)
        }
        .sheet(isPresented: $showArtMedium) {
            FilterPickerSheetView(title: "Medium",      options: availableArtMediums,        selected: $filterState.artMedium)
        }
    }

    // MARK: - Film

    private var filmSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(.film)
            filterRow(category: .film, title: "Year",         value: filterState.releaseYear,  onTap: { showYear = true },         onClear: { filterState.releaseYear  = nil })
            filterRow(category: .film, title: "Neighborhood", value: filterState.neighborhood, onTap: { showNeighborhood = true }, onClear: { filterState.neighborhood = nil })
            filterRow(category: .film, title: "Actor",        value: filterState.actorName,    onTap: { showActor = true },        onClear: { filterState.actorName    = nil })
        }
    }

    // MARK: - Park

    private var parkSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(.park)
            filterRow(category: .park, title: "Neighborhood", value: filterState.parkNeighborhood, onTap: { showParkNeighborhood = true }, onClear: { filterState.parkNeighborhood = nil })
            filterRow(category: .park, title: "Park Type",    value: filterState.parkType,         onTap: { showParkType = true },         onClear: { filterState.parkType         = nil })
        }
    }

    // MARK: - POPOS

    private var poposSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(.popos)
            filterRow(category: .popos, title: "Space Type", value: filterState.poposSpaceType, onTap: { showPOPOSSpaceType = true }, onClear: { filterState.poposSpaceType = nil })
            filterRow(category: .popos, title: "Feature",    value: filterState.poposFeature,   onTap: { showPOPOSFeature = true },   onClear: { filterState.poposFeature   = nil })
        }
    }

    // MARK: - Art

    private var artSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(.art)
            filterRow(category: .art, title: "Art Type", value: filterState.artType,   onTap: { showArtType = true },   onClear: { filterState.artType   = nil })
            filterRow(category: .art, title: "Medium",   value: filterState.artMedium, onTap: { showArtMedium = true }, onClear: { filterState.artMedium = nil })
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ category: AppCategory) -> some View {
        HStack(spacing: 6) {
            Circle().fill(category.color).frame(width: 8, height: 8)
            Text(category.displayName)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.appInk)
        }
    }

    private func filterRow(category: AppCategory, title: String, value: String?, onTap: @escaping () -> Void, onClear: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.appInk)
                Spacer()
                if let value {
                    Text(value)
                        .font(.system(size: 14))
                        .foregroundStyle(category.color)
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
