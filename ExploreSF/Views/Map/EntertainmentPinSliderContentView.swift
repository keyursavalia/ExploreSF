import SwiftUI
import MapKit

struct EntertainmentPinSliderContentView: View {
    let place: EntertainmentPlace
    let pin:   PlacePin
    @State private var vm: MapPinSliderViewModel

    init(place: EntertainmentPlace, pin: PlacePin) {
        self.place = place
        self.pin   = pin
        self._vm   = State(wrappedValue: MapPinSliderViewModel(pin: pin))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                if let scene = vm.lookAroundScene { lookAroundView(scene) }
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
            Text(AppCategory.entertainment.displayName.uppercased())
                .eyebrowStyle()
            Text(place.name)
                .font(.system(size: 22, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
                .lineLimit(3)
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
        VStack(alignment: .leading, spacing: 1) {
            infoRow(label: "Type",         value: place.licenseType,  icon: "ticket")
            if !place.neighborhood.isEmpty {
                infoRow(label: "Neighborhood", value: place.neighborhood, icon: "map")
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
        Button(action: vm.openInMaps) {
            Label("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.appPaper)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(AppCategory.entertainment.color)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
