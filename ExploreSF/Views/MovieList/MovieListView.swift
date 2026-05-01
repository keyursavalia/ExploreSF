import SwiftUI
import SwiftData

struct MovieListView: View {
    @Query(sort: \MovieLocation.title) private var allLocations: [MovieLocation]
    @State private var viewModel = MovieListViewModel()

    var body: some View {
        @Bindable var vm = viewModel

        NavigationStack {
            VStack(spacing: 0) {
                MovieListHeaderView(count: viewModel.filteredEntries.count)

                VStack(spacing: 8) {
                    SearchBarView(
                        text: $vm.searchText,
                        placeholder: "Search films, shows, locations..."
                    )
                    .padding(.horizontal, 16)

                    FilterBarView(
                        filterState:            $vm.filterState,
                        availableNeighborhoods: viewModel.availableNeighborhoods,
                        availableYears:         viewModel.availableYears,
                        onActorSelected:        { name in await viewModel.applyActorFilter(name: name) }
                    )
                }
                .padding(.bottom, 8)

                if viewModel.isLoadingActorFilter {
                    HStack(spacing: 8) {
                        ProgressView()
                        Text("Searching for actor...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }

                List(viewModel.filteredEntries) { entry in
                    NavigationLink {
                        MovieDetailView(viewModel: MovieDetailViewModel(entry: entry))
                    } label: {
                        MovieListCellView(
                            entry:     entry,
                            posterURL: viewModel.posterCache[entry.id]?.posterURL
                        )
                    }
                    .listRowSeparator(.hidden)
                    .onAppear {
                        Task { await viewModel.fetchPosterIfNeeded(for: entry) }
                    }
                }
                .listStyle(.plain)
            }
            .onChange(of: allLocations, initial: true) { _, new in
                viewModel.loadLocations(new.map(FilmLocation.init))
            }
        }
    }
}
