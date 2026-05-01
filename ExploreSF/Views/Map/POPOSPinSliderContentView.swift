import SwiftUI
import MapKit

struct POPOSPinSliderContentView: View {
    let place: POPOSPlace
    @State private var vm: MapPinSliderViewModel

    init(place: POPOSPlace, pin: PlacePin) {
        self.place = place
        self._vm   = State(wrappedValue: MapPinSliderViewModel(pin: pin))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                if let scene = vm.lookAroundScene { lookAroundView(scene) }
                amenitiesSection
                if !place.hours.isEmpty { hoursRow }
                directionsButton
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .task { await vm.loadData() }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(AppCategory.popos.displayName.uppercased())
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

    private var amenitiesSection: some View {
        HStack(spacing: 10) {
            if place.isIndoor { amenityChip("Indoor", icon: "building.2") }
            if place.hasFood  { amenityChip("Food", icon: "fork.knife") }
            if place.hasArt   { amenityChip("Art", icon: "paintpalette") }
            if place.hasRestrooms { amenityChip("Restrooms", icon: "figure.walk") }
        }
        .flexWrap()
    }

    private func amenityChip(_ label: String, icon: String) -> some View {
        Label(label, systemImage: icon)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(Color.appInk2)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.appPaper2)
            .clipShape(Capsule())
    }

    @ViewBuilder
    private var hoursRow: some View {
        HStack(spacing: 8) {
            Image(systemName: "clock")
                .font(.system(size: 13))
                .foregroundStyle(Color.appInk3)
            Text(place.hours)
                .font(.system(size: 13))
                .foregroundStyle(Color.appInk2)
        }
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

private extension View {
    func flexWrap() -> some View { self.fixedSize(horizontal: false, vertical: true) }
}
