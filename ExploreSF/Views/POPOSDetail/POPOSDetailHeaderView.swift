import SwiftUI

struct POPOSDetailHeaderView: View {
    let place: POPOSPlace

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Public Open Space")
                .eyebrowStyle()

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
