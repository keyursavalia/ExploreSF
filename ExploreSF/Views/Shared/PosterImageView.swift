import SwiftUI

struct PosterImageView: View {
    let url:          URL?
    let cornerRadius: CGFloat

    init(url: URL?, cornerRadius: CGFloat = 8) {
        self.url          = url
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        Group {
            if let url {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var placeholder: some View {
        Rectangle()
            .fill(Color(.systemGray5))
            .overlay {
                Image(systemName: "film")
                    .foregroundStyle(.secondary)
                    .font(.title2)
            }
    }
}
