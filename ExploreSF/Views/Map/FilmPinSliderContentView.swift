import SwiftUI
import MapKit

struct FilmPinSliderContentView: View {
    let pin: PlacePin
    let filmEntry: FilmEntry?
    @State private var vm: MapPinSliderViewModel

    init(pin: PlacePin, filmEntry: FilmEntry?) {
        self.pin       = pin
        self.filmEntry = filmEntry
        self._vm       = State(wrappedValue: MapPinSliderViewModel(pin: pin))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerRow
                if let scene = vm.lookAroundScene { lookAroundView(scene) }
                if let entry = filmEntry { filmDetailLink(entry: entry) }
                directionsButton
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .task { await vm.loadData() }
    }

    private var headerRow: some View {
        HStack(alignment: .top, spacing: 14) {
            PosterImageView(url: vm.filmSearchResult?.posterURL, cornerRadius: 8)
                .frame(width: 64, height: 96)

            VStack(alignment: .leading, spacing: 5) {
                Text(pin.displayName)
                    .font(.system(size: 18, weight: .semibold, design: .serif))
                    .foregroundStyle(Color.appInk)
                    .lineLimit(2)
                Text(pin.locationName)
                    .font(.system(size: 13))
                    .foregroundStyle(Color.appInk3)
                    .lineLimit(2)
                if vm.isLoadingTMDB {
                    ProgressView().scaleEffect(0.7).padding(.top, 4)
                }
            }
            Spacer()
        }
    }

    @ViewBuilder
    private func lookAroundView(_ scene: MKLookAroundScene) -> some View {
        LookAroundPreviewView(scene: scene)
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    @ViewBuilder
    private func filmDetailLink(_ entry: FilmEntry) -> some View {
        NavigationLink {
            MovieDetailView(viewModel: MovieDetailViewModel(entry: entry))
        } label: {
            Label("Full Film Details", systemImage: "info.circle.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.appPaper)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.appInk)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var directionsButton: some View {
        Button(action: vm.openInMaps) {
            Label("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.appInk)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.appCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12).stroke(Color.appCardEdge, lineWidth: 1)
                )
        }
    }
}
