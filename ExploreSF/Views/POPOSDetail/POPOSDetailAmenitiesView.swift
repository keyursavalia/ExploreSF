import SwiftUI

struct POPOSDetailAmenitiesView: View {
    let place: POPOSPlace

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Amenities")
                .eyebrowStyle()

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                if place.isIndoor    { amenityTile("Indoor",    icon: "building.2") }
                if place.hasFood     { amenityTile("Food",      icon: "fork.knife") }
                if place.hasArt      { amenityTile("Art",       icon: "paintpalette") }
                if place.hasRestrooms { amenityTile("Restrooms", icon: "figure.walk") }
            }

            if !place.seatingInfo.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Seating")
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(1.5)
                        .textCase(.uppercase)
                        .foregroundStyle(Color.appInk3)
                    Text(place.seatingInfo)
                        .font(.appBody)
                        .foregroundStyle(Color.appInk2)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.appCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appCardEdge, lineWidth: 1))
            }
        }
    }

    private func amenityTile(_ label: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(AppCategory.popos.color)
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.appInk)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.appCardEdge, lineWidth: 1))
    }
}
