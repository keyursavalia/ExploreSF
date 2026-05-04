import SwiftUI
import SwiftData

struct SavedView: View {
    @Query(sort: \SavedPlace.savedAt, order: .reverse) private var savedPlaces: [SavedPlace]
    @Environment(\.modelContext) private var modelContext
    @Environment(AppRouter.self) private var router

    @State private var isSelecting = false
    @State private var selectedIDs = Set<String>()

    private var groupedByCategory: [(AppCategory, [SavedPlace])] {
        let order: [AppCategory] = [.film, .popos, .park, .art]
        return order.compactMap { cat in
            let places = savedPlaces.filter { $0.categoryRaw == cat.rawValue }
            return places.isEmpty ? nil : (cat, places)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if savedPlaces.isEmpty {
                    emptyState
                } else {
                    list
                }
            }
            .background(Color.appPaper)
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }

    // MARK: - List

    private var list: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 4)

                ForEach(groupedByCategory, id: \.0) { category, places in
                    if groupedByCategory.count > 1 {
                        categoryHeader(category, count: places.count)
                    }
                    ForEach(places) { place in
                        savedRow(place)
                        Divider()
                            .background(Color.appHairline)
                            .padding(.horizontal, 16)
                    }
                }
            }
            .padding(.bottom, 100)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                Text("San Francisco · Saved")
                    .eyebrowStyle()
                Text("\(savedPlaces.count) \(savedPlaces.count == 1 ? "place" : "places")")
                    .font(.system(size: 36, weight: .regular, design: .serif))
                    .italic()
                    .foregroundStyle(Color.appInk)
                    .padding(.top, 4)
            }
            Spacer()
            if !isSelecting {
                Button("Select") {
                    isSelecting = true
                    selectedIDs.removeAll()
                }
                .font(.system(size: 15))
                .foregroundStyle(Color.appInk3)
                .padding(.bottom, 4)
            } else {
                HStack(spacing: 16) {
                    Button("Cancel") {
                        isSelecting = false
                        selectedIDs.removeAll()
                    }
                    .font(.system(size: 15))
                    .foregroundStyle(Color.appInk3)

                    if !selectedIDs.isEmpty {
                        Button("Delete (\(selectedIDs.count))") {
                            deleteSelected()
                        }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.red)
                    }
                }
                .padding(.bottom, 4)
            }
        }
    }

    // MARK: - Category header

    private func categoryHeader(_ category: AppCategory, count: Int) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Circle().fill(category.color).frame(width: 8, height: 8)
            Text(category.displayName)
                .font(.system(size: 22, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
            Spacer()
            Text("\(count)")
                .font(.appMeta)
                .foregroundStyle(Color.appInk3)
                .monospacedDigit()
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 10)
    }

    // MARK: - Row

    @ViewBuilder
    private func savedRow(_ place: SavedPlace) -> some View {
        let isSelected = selectedIDs.contains(place.id)
        let category = place.category ?? .film

        Button {
            if isSelecting {
                if isSelected { selectedIDs.remove(place.id) }
                else { selectedIDs.insert(place.id) }
            } else {
                router.navigateTo(pin: PlacePin(from: place))
            }
        } label: {
            HStack(spacing: 14) {
                if isSelecting {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22))
                        .foregroundStyle(isSelected ? category.color : Color.appInk4)
                        .animation(.easeInOut(duration: 0.15), value: isSelected)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(category.color.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: category.systemIcon)
                        .font(.system(size: 18))
                        .foregroundStyle(category.color)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(place.displayName)
                        .font(.system(size: 16, weight: .medium, design: .serif))
                        .foregroundStyle(Color.appInk)
                        .lineLimit(2)
                    Label(place.locationName, systemImage: "mappin")
                        .font(.appCaption)
                        .foregroundStyle(Color.appInk3)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                if !isSelecting {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.appInk4)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            if !isSelecting {
                Button(role: .destructive) {
                    delete(place)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "bookmark")
                .font(.system(size: 32))
                .foregroundStyle(Color.appInk4)
            Text("No saved places")
                .font(.system(size: 20, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
            Text("Tap the bookmark icon on any place to save it here.")
                .font(.appBody)
                .foregroundStyle(Color.appInk3)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
        .paperBackground()
    }

    // MARK: - Delete helpers

    private func delete(_ place: SavedPlace) {
        modelContext.delete(place)
    }

    private func deleteSelected() {
        let toDelete = savedPlaces.filter { selectedIDs.contains($0.id) }
        toDelete.forEach { modelContext.delete($0) }
        isSelecting = false
        selectedIDs.removeAll()
    }
}
