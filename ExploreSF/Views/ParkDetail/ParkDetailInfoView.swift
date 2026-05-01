import SwiftUI

struct ParkDetailInfoView: View {
    let place: ParkPlace

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            infoRow(label: "Size", value: place.acresFormatted, icon: "square.dashed")
            if !place.propertyType.isEmpty {
                infoRow(label: "Type", value: place.propertyType, icon: "tag")
            }
            if !place.neighborhood.isEmpty {
                infoRow(label: "Neighborhood", value: place.neighborhood, icon: "building.columns")
            }
            if !place.complex.isEmpty {
                infoRow(label: "Complex", value: place.complex, icon: "mappin.circle")
            }
        }
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.appCardEdge, lineWidth: 1))
    }

    private func infoRow(label: String, value: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(Color.appInk3)
                .frame(width: 20)
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(Color.appInk3)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.appInk)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 220, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
