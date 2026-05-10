import SwiftUI

struct POPOSDetailView: View {
    let place: POPOSPlace
    @State private var vm: POPOSDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(place: POPOSPlace) {
        self.place = place
        self._vm   = State(wrappedValue: POPOSDetailViewModel(place: place))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    heroSection
                    POPOSDetailHeaderView(place: place)
                    POPOSDetailInfoView(place: place)
                    POPOSDetailAmenitiesView(place: place)
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

    private var heroSection: some View {
        Group {
            if let scene = vm.lookAroundScene {
                LookAroundPreviewView(scene: scene)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppCategory.popos.color.opacity(0.2))
                    .overlay(
                        Image(systemName: "building.columns")
                            .font(.system(size: 48))
                            .foregroundStyle(AppCategory.popos.color.opacity(0.6))
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
    }

    private var directionsButton: some View {
        Button(action: vm.openInMaps) {
            Label("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.appPaper)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(AppCategory.popos.color)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
