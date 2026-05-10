import SwiftUI
import MapKit

struct ParkDetailHeaderView: View {
    let place: ParkPlace

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MapSnapshotView(
                id: place.id,
                coordinate: place.coordinate,
                style: .parkSatellite,
                category: .park,
                cornerRadius: 20,
                snapshotSize: CGSize(width: 390, height: 220),
                iconSize: 48
            )
            .frame(maxWidth: .infinity)
            .frame(height: 220)

            Text("Parks & Recreation")
                .eyebrowStyle()
                .padding(.top, 24)

            Text(place.name)
                .font(.system(size: 34, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
                .padding(.top, 8)

            if !place.address.isEmpty {
                Label(place.address, systemImage: "mappin.and.ellipse")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.appInk3)
                    .padding(.top, 6)
            }
        }
    }
}
