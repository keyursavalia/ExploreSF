import SwiftUI

struct MovieListHeaderView: View {
    let count: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("CineMap SF")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("\(count) film\(count == 1 ? "" : "s") shot in San Francisco")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}
