import SwiftUI

struct POPOSDetailHeaderView: View {
    let place: POPOSPlace

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RoundedRectangle(cornerRadius: 20)
                .fill(AppCategory.popos.color.opacity(0.2))
                .overlay(
                    Image(systemName: "building.columns")
                        .font(.system(size: 48))
                        .foregroundStyle(AppCategory.popos.color.opacity(0.6))
                )
                .frame(maxWidth: .infinity)
                .frame(height: 220)

            Text("Public Open Space")
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
