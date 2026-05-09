import SwiftUI
import MapKit

struct FoodTruckInfoSheet: View {
    let place: FoodTruckPlace

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                foodItemsSection
                infoRows
                directionsButton
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(place.facilityType.displayName.uppercased())
                .eyebrowStyle()
            Text(place.name)
                .font(.system(size: 22, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
                .lineLimit(3)
            if !place.locationDescription.isEmpty {
                Label(place.locationDescription, systemImage: "mappin.and.ellipse")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.appInk3)
            }
        }
    }

    @ViewBuilder
    private var foodItemsSection: some View {
        let items = foodItemsList
        if !items.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("ON THE MENU")
                    .eyebrowStyle()
                FlowLayout(spacing: 6) {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.appInk2)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.appPaper2)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }

    private var infoRows: some View {
        VStack(alignment: .leading, spacing: 1) {
            infoRow(label: "Type", value: place.facilityType.displayName, icon: place.facilityType.systemIcon)
            if !place.permitNumber.isEmpty {
                infoRow(label: "Permit", value: place.permitNumber, icon: "doc.text")
            }
        }
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appCardEdge, lineWidth: 1))
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

    private var directionsButton: some View {
        Button {
            let item = MKMapItem(placemark: MKPlacemark(coordinate: place.coordinate))
            item.name = place.name
            item.openInMaps(launchOptions: [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
            ])
        } label: {
            Label("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.appPaper)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(UtilityToggleButtonsView.foodTruckColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private var foodItemsList: [String] {
        place.foodItems
            .components(separatedBy: ":")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
}

// MARK: - Simple flow layout for food item chips

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let maxWidth = bounds.width
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
