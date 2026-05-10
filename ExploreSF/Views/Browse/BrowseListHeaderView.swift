import SwiftUI

struct BrowseListHeaderView: View {
    let activeCategories: Set<AppCategory>
    let totalCount: Int

    private var titleText: String {
        if activeCategories.count == 1, let cat = activeCategories.first {
            return cat.displayName
        }
        return "\(totalCount) places"
    }

    private var titleIsItalic: Bool { activeCategories.count != 1 }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Explore SF · Browse")
                .eyebrowStyle()

            if titleIsItalic {
                Text("\(totalCount) places")
                    .font(.system(size: 36, weight: .regular, design: .serif))
                    .italic()
                    .foregroundStyle(Color.appInk)
                    .padding(.top, 4)
            } else {
                Text(titleText)
                    .font(.system(size: 36, weight: .medium, design: .serif))
                    .foregroundStyle(Color.appInk)
                    .padding(.top, 4)
            }

        }
    }
}
