import SwiftUI
import MapKit

struct MapPinSliderView: View {
    let selectedLocation: FilmLocation
    let filmEntry:        FilmEntry

    @State   private var viewModel: MapPinViewModel
    @Environment(\.dismiss) private var dismiss

    init(selectedLocation: FilmLocation, filmEntry: FilmEntry) {
        self.selectedLocation = selectedLocation
        self.filmEntry        = filmEntry
        self._viewModel       = State(wrappedValue: MapPinViewModel(location: selectedLocation))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    lookAroundSection
                    actionButtons
                }
                .padding(.vertical, 20)
            }
            .navigationTitle(selectedLocation.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .task { await viewModel.loadData() }
    }

    // MARK: - Subviews

    private var headerSection: some View {
        HStack(alignment: .top, spacing: 16) {
            PosterImageView(url: viewModel.searchResult?.posterURL, cornerRadius: 8)
                .frame(width: 72, height: 108)

            VStack(alignment: .leading, spacing: 6) {
                Text(selectedLocation.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(2)

                Text(selectedLocation.releaseYear)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Label(selectedLocation.locationName, systemImage: "mappin.and.ellipse")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                if viewModel.isLoadingTMDB {
                    ProgressView().scaleEffect(0.7)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var lookAroundSection: some View {
        if let scene = viewModel.lookAroundScene {
            VStack(alignment: .leading, spacing: 8) {
                Label("360° Street View", systemImage: "binoculars")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)

                LookAroundPreviewView(scene: scene)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 16)
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 10) {
            NavigationLink {
                MovieDetailView(viewModel: MovieDetailViewModel(entry: filmEntry))
            } label: {
                Label("Full Movie Details", systemImage: "info.circle.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.borderedProminent)

            Button(action: viewModel.openInMaps) {
                Label("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.bordered)
        }
        .padding(.horizontal, 20)
    }
}
