import SwiftUI

struct MovieListCellView: View {
    let entry:     FilmEntry
    let posterURL: URL?

    var body: some View {
        HStack(spacing: 12) {
            PosterImageView(url: posterURL, cornerRadius: 6)
                .frame(width: 56, height: 84)

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(entry.releaseYear)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if let first = entry.locations.first {
                    Label(first.locationName, systemImage: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                if entry.locations.count > 1 {
                    Text("+\(entry.locations.count - 1) more location\(entry.locations.count > 2 ? "s" : "")")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}
