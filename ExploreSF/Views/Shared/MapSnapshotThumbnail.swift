import SwiftUI
import MapKit

struct MapSnapshotThumbnail: View {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let category: AppCategory
    let cornerRadius: CGFloat
    let size: CGSize

    @State private var image: UIImage? = nil

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(category.color.opacity(0.2))

            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(category.color.opacity(0.18))
                    )
                    .transition(.opacity.animation(.easeInOut(duration: 0.35)))
            } else {
                Image(systemName: category.systemIcon)
                    .font(.system(size: size.width * 0.3))
                    .foregroundStyle(category.color.opacity(0.6))
            }
        }
        .task {
            guard image == nil else { return }
            image = await MapSnapshotService.shared.snapshot(
                id: id,
                coordinate: coordinate,
                size: size
            )
        }
    }
}
