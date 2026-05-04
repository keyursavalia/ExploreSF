import SwiftUI
import MapKit

struct ArtPinSliderContentView: View {
    let place: ArtPlace
    let pin: PlacePin
    @State private var vm: MapPinSliderViewModel

    init(place: ArtPlace, pin: PlacePin) {
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
            Text(AppCategory.art.displayName.uppercased())
                .eyebrowStyle()
            Text(place.title)
                .font(.system(size: 22, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
                .lineLimit(3)
            if !place.locationName.isEmpty {
                Label(place.locationName, systemImage: "mappin.and.ellipse")
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
            if !place.artType.isEmpty  { infoRow(label: "Type",   value: place.artType,  icon: "tag") }
            if !place.medium.isEmpty   { infoRow(label: "Medium", value: place.medium,   icon: "paintbrush") }
            if !place.locationDescription.isEmpty {
                infoRow(label: "Location", value: place.locationDescription, icon: "location")
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
                .background(AppCategory.art.color)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
