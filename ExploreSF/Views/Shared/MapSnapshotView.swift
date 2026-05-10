import SwiftUI
import MapKit

struct MapSnapshotView: View {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let style: MapSnapshotStyle
    let category: AppCategory
    let cornerRadius: CGFloat
    let snapshotSize: CGSize
    let iconSize: CGFloat

    @State private var image: UIImage? = nil

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(category.color.opacity(0.2))

            if image == nil {
                Image(systemName: category.systemIcon)
                    .font(.system(size: iconSize))
                    .foregroundStyle(category.color.opacity(0.6))
            }

            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .transition(.opacity.animation(.easeInOut(duration: 0.4)))
            }
        }
        .task {
            guard image == nil else { return }
            image = await MapSnapshotService.shared.snapshot(
                id: id,
                coordinate: coordinate,
                style: style,
                size: snapshotSize
            )
        }
    }
}
