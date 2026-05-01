import SwiftUI

struct MapPinSliderView: View {
    let pin: PlacePin
    let mapViewModel: MapViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                switch pin.category {
                case .film:
                    FilmPinSliderContentView(
                        pin: pin,
                        filmEntry: mapViewModel.filmEntry(for: pin)
                    )
                case .popos:
                    if let place = mapViewModel.poposPlace(for: pin) {
                        POPOSPinSliderContentView(place: place, pin: pin)
                    } else {
                        ProgressView()
                    }
                case .park:
                    if let place = mapViewModel.parkPlace(for: pin) {
                        ParkPinSliderContentView(place: place, pin: pin)
                    } else {
                        ProgressView()
                    }
                }
            }
            .navigationTitle(pin.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .paperBackground()
    }
}
