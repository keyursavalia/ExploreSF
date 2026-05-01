import SwiftUI

struct MovieDetailLocationsView: View {
    let locations:     [FilmLocation]
    let onLocationTap: (FilmLocation) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Filmed in San Francisco")
                .font(.headline)
                .padding(.horizontal, 16)

            VStack(spacing: 0) {
                ForEach(locations) { location in
                    Button {
                        onLocationTap(location)
                    } label: {
                        MovieDetailLocationRowView(location: location)
                            .padding(.horizontal, 16)
                    }

                    if location.id != locations.last?.id {
                        Divider().padding(.leading, 52)
                    }
                }
            }
        }
    }
}
