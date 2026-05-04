import SwiftUI
import SwiftData

struct BrowseListView: View {
    @Query(sort: \MovieLocation.title)  private var allFilm:  [MovieLocation]
    @Query(sort: \POPOSLocation.name)   private var allPOPOS: [POPOSLocation]
    @Query(sort: \ParkLocation.name)    private var allParks: [ParkLocation]

    @State private var vm = BrowseListViewModel()
    @State private var showCategoryPicker = false
    @State private var selectedFilmEntry: FilmEntry?  = nil
    @State private var selectedPOPOS:     POPOSPlace? = nil
    @State private var selectedPark:      ParkPlace?  = nil
    @State private var expandedCategory:  AppCategory? = nil

    @Environment(AppRouter.self) private var router

    // Ordered categories that are active AND have results
    private var sectionsToShow: [AppCategory] {
        [AppCategory.film, .popos, .park].filter { cat in
            switch cat {
            case .film:  return router.activeCategories.contains(.film)  && !vm.filteredFilm.isEmpty
            case .popos: return router.activeCategories.contains(.popos) && !vm.filteredPOPOS.isEmpty
            case .park:  return router.activeCategories.contains(.park)  && !vm.filteredParks.isEmpty
            default:     return false
            }
        }
    }

    private var isMultiCategory: Bool { sectionsToShow.count > 1 }

    private func isExpanded(_ category: AppCategory) -> Bool {
        !isMultiCategory || expandedCategory == category
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    headerArea
                    searchRow.padding(.horizontal, 20).padding(.top, 20)

                    if vm.totalCount == 0 {
                        emptyState
                    } else {
                        filmSection
                        poposSection
                        parkSection
                    }
                }
                .padding(.bottom, 100)
            }
            .background(Color.appPaper)
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showCategoryPicker) {
            CategoryPickerView(
                isFirstRun:        false,
                initialCategories: router.activeCategories,
                onApply: { cats in
                    router.applyCategories(cats)
                    showCategoryPicker = false
                }
            )
            .presentationDragIndicator(.visible)
        }
        .sheet(item: $selectedFilmEntry) { entry in
            NavigationStack { MovieDetailView(viewModel: MovieDetailViewModel(entry: entry)) }
        }
        .sheet(item: $selectedPOPOS) { place in
            POPOSDetailView(place: place)
        }
        .sheet(item: $selectedPark) { place in
            ParkDetailView(place: place, polygon: nil)
        }
        .onChange(of: allFilm, initial: true)  { _, new in vm.loadFilm(new.map(FilmLocation.init)) }
        .onChange(of: allPOPOS, initial: true) { _, new in vm.loadPOPOS(new.map(POPOSPlace.init)) }
        .onChange(of: allParks, initial: true) { _, new in vm.loadParks(new.map(ParkPlace.init)) }
        .onChange(of: router.activeCategories, initial: true) { _, cats in
            vm.activeCategories = cats
            if let current = expandedCategory, !cats.contains(current) {
                expandedCategory = firstSection(in: cats)
            } else if expandedCategory == nil {
                expandedCategory = firstSection(in: cats)
            }
        }
        // When results load and only one section has data, make sure expandedCategory is set
        .onChange(of: sectionsToShow) { _, sections in
            if let current = expandedCategory, !sections.contains(current) {
                expandedCategory = sections.first
            } else if expandedCategory == nil {
                expandedCategory = sections.first
            }
        }
    }

    private func firstSection(in cats: Set<AppCategory>) -> AppCategory? {
        [AppCategory.film, .popos, .park].first { cats.contains($0) }
    }

    // MARK: - Header

    private var headerArea: some View {
        BrowseListHeaderView(
            activeCategories: router.activeCategories,
            totalCount: vm.totalCount
        )
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    // MARK: - Search row

    private var searchRow: some View {
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
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appCardEdge, lineWidth: 1))

            Button { showCategoryPicker = true } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.appInk)
                    .frame(width: 44, height: 44)
                    .background(Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appCardEdge, lineWidth: 1))
            }
        }
    }

    // MARK: - Film section

    @ViewBuilder
    private var filmSection: some View {
        if router.activeCategories.contains(.film) && !vm.filteredFilm.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                if isMultiCategory {
                    accordionHeader(.film, count: vm.filteredFilm.count, isExpanded: isExpanded(.film))
                }
                if isExpanded(.film) {
                    ForEach(Array(vm.filteredFilm.enumerated()), id: \.element.id) { idx, entry in
                        Button { selectedFilmEntry = entry } label: {
                            FilmPlaceRowView(
                                location:  entry.locations[0],
                                index:     idx + 1,
                                posterURL: vm.posterCache[entry.id]?.posterURL
                            )
                            .padding(.horizontal, 16)
                        }
                        .buttonStyle(.plain)
                        .onAppear { Task { await vm.fetchPosterIfNeeded(for: entry) } }
                        Divider().background(Color.appHairline).padding(.horizontal, 16)
                    }
                }
            }
        }
    }

    // MARK: - POPOS section

    @ViewBuilder
    private var poposSection: some View {
        if router.activeCategories.contains(.popos) && !vm.filteredPOPOS.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                if isMultiCategory {
                    accordionHeader(.popos, count: vm.filteredPOPOS.count, isExpanded: isExpanded(.popos))
                }
                if isExpanded(.popos) {
                    ForEach(Array(vm.filteredPOPOS.enumerated()), id: \.element.id) { idx, place in
                        Button { selectedPOPOS = place } label: {
                            POPOSPlaceRowView(place: place, index: idx + 1)
                                .padding(.horizontal, 16)
                        }
                        .buttonStyle(.plain)
                        Divider().background(Color.appHairline).padding(.horizontal, 16)
                    }
                }
            }
        }
    }

    // MARK: - Park section

    @ViewBuilder
    private var parkSection: some View {
        if router.activeCategories.contains(.park) && !vm.filteredParks.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                if isMultiCategory {
                    accordionHeader(.park, count: vm.filteredParks.count, isExpanded: isExpanded(.park))
                }
                if isExpanded(.park) {
                    ForEach(Array(vm.filteredParks.enumerated()), id: \.element.id) { idx, place in
                        Button { selectedPark = place } label: {
                            ParkPlaceRowView(place: place, index: idx + 1)
                                .padding(.horizontal, 16)
                        }
                        .buttonStyle(.plain)
                        Divider().background(Color.appHairline).padding(.horizontal, 16)
                    }
                }
            }
        }
    }

    // MARK: - Accordion header

    private func accordionHeader(_ category: AppCategory, count: Int, isExpanded: Bool) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.22)) {
                expandedCategory = (expandedCategory == category) ? nil : category
            }
        } label: {
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
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.appInk3)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeInOut(duration: 0.22), value: isExpanded)
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 10)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Empty state

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
