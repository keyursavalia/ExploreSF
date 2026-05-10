import SwiftUI
import MapKit

struct ParkDetailView: View {
    let place: ParkPlace
    let polygon: ParkPolygon?
    @State private var vm: ParkDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(place: ParkPlace, polygon: ParkPolygon?) {
        self.place   = place
        self.polygon = polygon
        self._vm     = State(wrappedValue: ParkDetailViewModel(place: place, polygon: polygon))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    heroSection
                    ParkDetailHeaderView(place: place)
                    ParkDetailInfoView(place: place)
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
                    .fill(AppCategory.park.color.opacity(0.2))
                    .overlay(
                        Image(systemName: "tree")
                            .font(.system(size: 48))
                            .foregroundStyle(AppCategory.park.color.opacity(0.6))
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
                .background(AppCategory.park.color)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
