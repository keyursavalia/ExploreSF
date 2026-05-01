import SwiftUI

struct MovieDetailHeaderView: View {
    let posterURL: URL?
    let title:     String
    let year:      String
    let rating:    String?
    let tagline:   String?

    var body: some View {
        VStack(spacing: 16) {
            PosterImageView(url: posterURL, cornerRadius: 12)
                .frame(width: 140, height: 210)
                .shadow(radius: 8, y: 4)

            VStack(spacing: 6) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                HStack(spacing: 8) {
                    Text(year)
                        .foregroundStyle(.secondary)

                    if let rating {
                        Text("·").foregroundStyle(.secondary)
                        Label(rating, systemImage: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
                .font(.subheadline)

                if let tagline {
                    Text("\"\(tagline)\"")
                        .font(.caption)
                        .italic()
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.horizontal)
    }
}
