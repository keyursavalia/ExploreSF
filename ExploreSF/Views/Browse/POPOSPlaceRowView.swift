import SwiftUI
import MapKit

struct POPOSPlaceRowView: View {
    let place: POPOSPlace
    let index: Int

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            indexNumeral
            thumbnail
            bodyText
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(Color.appInk4)
                .padding(.top, 8)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
        .contentShape(Rectangle())
    }

    private var indexNumeral: some View {
        Text(String(format: "%02d", index))
            .font(.system(size: 14, weight: .regular, design: .serif))
            .italic()
            .foregroundStyle(Color.appInk3)
            .frame(width: 26, alignment: .trailing)
            .padding(.top, 6)
    }

    private var thumbnail: some View {
        MapSnapshotThumbnail(
            id: place.id,
            coordinate: place.coordinate,
            category: .popos,
            cornerRadius: 8,
            size: CGSize(width: 64, height: 80)
        )
        .frame(width: 64, height: 80)
    }

    private var bodyText: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(place.name)
                .font(.system(size: 19, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
                .lineLimit(2)
            if !place.spaceType.isEmpty {
                Text(place.spaceType)
                    .font(.appMeta)
                    .foregroundStyle(Color.appInk3)
            }
            Label(place.address.isEmpty ? "San Francisco" : place.address, systemImage: "mappin")
                .font(.appCaption)
                .foregroundStyle(Color.appInk3)
                .lineLimit(1)
                .padding(.top, 4)
        }
        .padding(.top, 2)
    }
}
