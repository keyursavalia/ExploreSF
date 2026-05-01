import SwiftUI
import MapKit

struct ParkPinSliderContentView: View {
    let place: ParkPlace
    @State private var vm: MapPinSliderViewModel

    init(place: ParkPlace, pin: PlacePin) {
        self.place = place
        self._vm   = State(wrappedValue: MapPinSliderViewModel(pin: pin))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                if let scene = vm.lookAroundScene { lookAroundView(scene: scene) }
                infoRows
                directionsButton
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .task { await vm.loadData() }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(AppCategory.park.displayName.uppercased())
                .eyebrowStyle()
            Text(place.name)
                .font(.system(size: 22, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
            if !place.address.isEmpty {
                Label(place.address, systemImage: "mappin.and.ellipse")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.appInk3)
            }
        }
    }

    @ViewBuilder
    private func lookAroundView(_ scene: MKLookAroundScene) -> some View {
        LookAroundPreviewView(scene: scene)
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var infoRows: some View {
        VStack(spacing: 1) {
            if !place.acresFormatted.isEmpty {
                infoRow(label: "Size", value: place.acresFormatted, icon: "square.dashed")
            }
            if !place.propertyType.isEmpty {
                infoRow(label: "Type", value: place.propertyType, icon: "tag")
            }
            if !place.neighborhood.isEmpty {
                infoRow(label: "Neighborhood", value: place.neighborhood, icon: "building.columns")
            }
        }
        .background(Color.appCard)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appCardEdge, lineWidth: 1))
    }

    private func infoRow(label: String, value: String, icon: String) -> some View {
        HStack(spacing: 12) {
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
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private var directionsButton: some View {
        Button(action: vm.openInMaps) {
            Label("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.appInk)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.appCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12).stroke(Color.appCardEdge, lineWidth: 1)
                )
        }
    }
}
