import SwiftUI

struct MovieDetailView: View {
    @State var viewModel: MovieDetailViewModel
    @Environment(AppRouter.self) private var router

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 80)
            } else {
                VStack(spacing: 28) {
                    MovieDetailHeaderView(
                        posterURL: viewModel.posterURL,
                        title:     viewModel.displayTitle,
                        year:      viewModel.displayYear,
                        rating:    viewModel.rating,
                        tagline:   viewModel.tagline
                    )

                    MovieDetailInfoView(
                        director: viewModel.director,
                        runtime:  viewModel.runtime,
                        genres:   viewModel.genres,
                        cast:     viewModel.topCast,
                        overview: viewModel.overview
                    )

                    MovieDetailLocationsView(locations: viewModel.entry.locations) { location in
                        router.navigateTo(pin: PlacePin(from: location))
                    }
                }
                .padding(.vertical, 20)
            }
        }
        .navigationTitle(viewModel.displayTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if let first = viewModel.entry.locations.first {
                ToolbarItem(placement: .primaryAction) {
                    BookmarkButton(pin: PlacePin(from: first))
                }
            }
        }
        .task { await viewModel.loadDetails() }
    }
}
