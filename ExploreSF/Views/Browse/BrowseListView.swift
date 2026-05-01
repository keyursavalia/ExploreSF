import SwiftUI
import SwiftData

struct BrowseListView: View {
    @Query(sort: \MovieLocation.title)  private var allFilm:  [MovieLocation]
    @Query(sort: \POPOSLocation.name)   private var allPOPOS: [POPOSLocation]
    @Query(sort: \ParkLocation.name)    private var allParks: [ParkLocation]

    @State private var vm = BrowseListViewModel()
    @State private var showCategoryPicker = false

    @Environment(AppRouter.self) private var router

    // Film detail navigation
    @State private var selectedFilmEntry: FilmEntry? = nil
    @State private var selectedPOPOS: POPOSPlace? = nil
    @State private var selectedPark: ParkPlace? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: []) {
                    VStack(alignment: .leading, spacing: 0) {
                        BrowseListHeaderView(
                            activeCategories: router.activeCategories,
                            totalCount: vm.totalCount,
                            onChangeCategoriesTap: { showCategoryPicker = true }
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                        searchBar
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                    }

                    if vm.totalCount == 0 {
                        emptyState
                    } else {
                        categorySection(for: .film)
                        categorySection(for: .popos)
                        categorySection(for: .park)
                    }
                }
                .padding(.bottom, 100)
            }
            .background(Color.appPaper)
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showCategoryPicker) {
            CategoryPickerView(isFirstRun: false, onApply: { categories in
                router.applyCategories(categories)
                showCategoryPicker = false
            }, onClose: { showCategoryPicker = false })
        }
        .sheet(item: $selectedFilmEntry) { entry in
            NavigationStack {
                MovieDetailView(viewModel: MovieDetailViewModel(entry: entry))
            }
        }
        .onChange(of: allFilm, initial: true)  { _, new in vm.loadFilm(new.map(FilmLocation.init)) }
        .onChange(of: allPOPOS, initial: true) { _, new in vm.loadPOPOS(new.map(POPOSPlace.init)) }
        .onChange(of: allParks, initial: true) { _, new in vm.loadParks(new.map(ParkPlace.init)) }
        .onChange(of: router.activeCategories, initial: true) { _, cats in
            vm.activeCategories = cats
        }
    }

    private var searchBar: some View {
        @Bindable var bindVm = vm
        return HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.appInk3)
                TextField("Search…", text: $bindVm.searchText)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.appInk)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12).stroke(Color.appCardEdge, lineWidth: 1)
            )
        }
    }

    @ViewBuilder
    private func categorySection(for category: AppCategory) -> some View {
        let items = itemsForCategory(category)
        if !items.isEmpty && router.activeCategories.contains(category) {
            VStack(alignment: .leading, spacing: 0) {
                if router.activeCategories.count > 1 {
                    categorySectionHeader(category, count: items.count)
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 10)
                }

                VStack(spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                        rowView(for: item, category: category, index: idx + 1)
                            .padding(.horizontal, 16)
                        Divider()
                            .background(Color.appHairline)
                            .padding(.horizontal, 16)
                    }
                }
            }
        }
    }

    private func categorySectionHeader(_ category: AppCategory, count: Int) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Circle()
                .fill(category.color)
                .frame(width: 8, height: 8)
            Text(category.displayName)
                .font(.system(size: 22, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
            Spacer()
            Text("\(count)")
                .font(.appMeta)
                .foregroundStyle(Color.appInk3)
                .monospacedDigit()
        }
    }

    @ViewBuilder
    private func rowView(for item: AnyHashable, category: AppCategory, index: Int) -> some View {
        switch category {
        case .film:
            if let loc = item.base as? FilmLocation {
                Button {
                    let entry = FilmEntry(
                        id: loc.title + loc.releaseYear,
                        title: loc.title,
                        releaseYear: loc.releaseYear,
                        locations: vm.filteredFilm.filter { $0.title == loc.title && $0.releaseYear == loc.releaseYear }
                    )
                    selectedFilmEntry = entry
                } label: {
                    FilmPlaceRowView(location: loc, index: index)
                }
                .buttonStyle(.plain)
            }
        case .popos:
            if let place = item.base as? POPOSPlace {
                Button { selectedPOPOS = place } label: {
                    POPOSPlaceRowView(place: place, index: index)
                }
                .buttonStyle(.plain)
                .sheet(item: $selectedPOPOS) { p in
                    POPOSDetailView(place: p)
                }
            }
        case .park:
            if let place = item.base as? ParkPlace {
                Button { selectedPark = place } label: {
                    ParkPlaceRowView(place: place, index: index)
                }
                .buttonStyle(.plain)
                .sheet(item: $selectedPark) { p in
                    ParkDetailView(place: p, polygon: nil)
                }
            }
        }
    }

    private func itemsForCategory(_ category: AppCategory) -> [AnyHashable] {
        switch category {
        case .film:  return vm.filteredFilm.map { AnyHashable($0) }
        case .popos: return vm.filteredPOPOS.map { AnyHashable($0) }
        case .park:  return vm.filteredParks.map { AnyHashable($0) }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 32))
                .foregroundStyle(Color.appInk4)
            Text("No results")
                .font(.system(size: 20, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
            Text("Try a different search or change your active categories.")
                .font(.appBody)
                .foregroundStyle(Color.appInk3)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal, 32)
    }
}
