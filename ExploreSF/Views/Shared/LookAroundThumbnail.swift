import SwiftUI
import MapKit

struct LookAroundThumbnail: View {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let category: AppCategory
    let cornerRadius: CGFloat

    @State private var scene: MKLookAroundScene? = nil
    @State private var fetched = false

    var body: some View {
        ZStack {
            if fetched, let scene {
                LookAroundThumbnailPreview(scene: scene)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(category.color.opacity(0.2))
                    .overlay(
                        Image(systemName: category.systemIcon)
                            .font(.system(size: 20))
                            .foregroundStyle(category.color.opacity(0.6))
                    )
            }
        }
        .task {
            guard !fetched else { return }
            scene = await LookAroundSceneCache.shared.scene(for: id, coordinate: coordinate)
            fetched = true
        }
    }
}

private struct LookAroundThumbnailPreview: UIViewControllerRepresentable {
    let scene: MKLookAroundScene

    func makeUIViewController(context: Context) -> MKLookAroundViewController {
        let vc = MKLookAroundViewController()
        vc.scene = scene
        vc.view.isUserInteractionEnabled = false
        return vc
    }

    func updateUIViewController(_ vc: MKLookAroundViewController, context: Context) {
        vc.scene = scene
    }
}
