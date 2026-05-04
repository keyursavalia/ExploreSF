import SwiftUI

struct FilmPlaceRowView: View {
    let location:  FilmLocation
    let index:     Int
    let posterURL: URL?

    init(location: FilmLocation, index: Int, posterURL: URL? = nil) {
        self.location  = location
        self.index     = index
        self.posterURL = posterURL
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            indexNumeral
            thumbnail
            bodyText
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(Color.appInk4)
                .padding(.top, 8)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
        .contentShape(Rectangle())
    }

    private var indexNumeral: some View {
        Text(String(format: "%02d", index))
            .font(.system(size: 14, weight: .regular, design: .serif))
            .italic()
            .foregroundStyle(Color.appInk3)
            .frame(width: 26, alignment: .trailing)
            .padding(.top, 6)
    }

    private var thumbnail: some View {
        Group {
            if let url = posterURL {
                PosterImageView(url: url, cornerRadius: 8)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppCategory.film.color.opacity(0.15))
                    .overlay(
                        Image(systemName: "film")
                            .font(.system(size: 20))
                            .foregroundStyle(AppCategory.film.color.opacity(0.6))
                    )
            }
        }
        .frame(width: 54, height: 80)
    }

    private var bodyText: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(location.title)
                .font(.system(size: 17, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
                .lineLimit(2)
            Text(location.releaseYear)
                .font(.appMeta)
                .foregroundStyle(Color.appInk3)
            Label(location.locationName, systemImage: "mappin")
                .font(.appCaption)
                .foregroundStyle(Color.appInk3)
                .lineLimit(1)
                .padding(.top, 4)
        }
        .padding(.top, 2)
    }
}
