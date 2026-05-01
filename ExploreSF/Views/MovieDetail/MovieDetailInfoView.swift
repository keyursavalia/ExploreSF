import SwiftUI

struct MovieDetailInfoView: View {
    let director: String?
    let runtime:  String?
    let genres:   String?
    let cast:     [TMDBCastMember]
    let overview: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if director != nil || runtime != nil || genres != nil {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        if let director { metaChip(icon: "megaphone",    text: director) }
                        if let runtime  { metaChip(icon: "clock",        text: runtime) }
                        if let genres   { metaChip(icon: "film.stack",   text: genres) }
                    }
                    .padding(.horizontal, 16)
                }
            }

            if let overview {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Overview")
                        .font(.headline)
                        .padding(.horizontal, 16)
                    Text(overview)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 16)
                }
            }

            if !cast.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cast")
                        .font(.headline)
                        .padding(.horizontal, 16)

                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(cast) { member in
                            HStack {
                                Text(member.name)
                                    .font(.subheadline)
                                Spacer()
                                Text(member.character)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
        }
    }

    private func metaChip(icon: String, text: String) -> some View {
        Label(text, systemImage: icon)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray6), in: Capsule())
    }
}
