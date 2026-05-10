import SwiftUI

struct ArtDetailView: View {
    let place: ArtPlace
    @State private var vm: ArtDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(place: ArtPlace) {
        self.place = place
        self._vm   = State(wrappedValue: ArtDetailViewModel(place: place))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    infoSection
                    if !place.descriptionText.isEmpty { descriptionSection }
                    directionsButton
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
            .background(Color.appPaper)
            .navigationTitle("")
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    BookmarkButton(pin: PlacePin(from: place))
                }
            }
        }
        .task { await vm.loadData() }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Group {
                if let scene = vm.lookAroundScene {
                    LookAroundPreviewView(scene: scene)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppCategory.art.color.opacity(0.2))
                        .overlay(
                            Image(systemName: "photo.artframe")
                                .font(.system(size: 48))
                                .foregroundStyle(AppCategory.art.color.opacity(0.6))
                        )
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 220)

            Text(AppCategory.art.displayName)
                .eyebrowStyle()
                .padding(.top, 24)

            Text(place.title)
                .font(.system(size: 30, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
                .padding(.top, 8)

            if !place.locationName.isEmpty {
                Label(place.locationName, systemImage: "mappin.and.ellipse")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.appInk3)
                    .padding(.top, 6)
            }
        }
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 1) {
            if !place.artType.isEmpty {
                infoRow(label: "Type",        value: place.artType,             icon: "tag")
            }
            if !place.medium.isEmpty {
                infoRow(label: "Medium",      value: place.medium,              icon: "paintbrush")
            }
            if !place.locationDescription.isEmpty {
                infoRow(label: "Location",    value: place.locationDescription, icon: "location")
            }
            if !place.accessibility.isEmpty {
                infoRow(label: "Access",      value: place.accessibility,       icon: "figure.roll")
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

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About")
                .eyebrowStyle()
            Text(place.descriptionText)
                .font(.appBody)
                .foregroundStyle(Color.appInk2)
                .lineSpacing(4)
        }
    }

    private var directionsButton: some View {
        Button(action: vm.openInMaps) {
            Label("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.appPaper)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(AppCategory.art.color)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
