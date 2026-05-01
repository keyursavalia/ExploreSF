import SwiftUI

struct POPOSDetailInfoView: View {
    let place: POPOSPlace

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            if !place.hours.isEmpty {
                infoRow(label: "Hours", value: place.hours, icon: "clock")
            }
            if !place.spaceType.isEmpty {
                infoRow(label: "Type", value: place.spaceType, icon: "tag")
            }
            if !place.descriptionText.isEmpty {
                descriptionRow
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
                .frame(maxWidth: 200, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var descriptionRow: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("About")
                .font(.system(size: 11, weight: .semibold))
                .tracking(1.5)
                .textCase(.uppercase)
                .foregroundStyle(Color.appInk3)
            Text(place.descriptionText)
                .font(.appBody)
                .foregroundStyle(Color.appInk2)
                .lineSpacing(3)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
