import SwiftUI

struct BrowseListHeaderView: View {
    let activeCategories: Set<AppCategory>
    let totalCount: Int
    let onChangeCategoriesTap: () -> Void

    private var titleText: String {
        if activeCategories.count == 1, let cat = activeCategories.first {
            return cat.displayName
        }
        return "\(totalCount) places"
    }

    private var titleIsItalic: Bool { activeCategories.count != 1 }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("San Francisco · Browse")
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

            Button(action: onChangeCategoriesTap) {
                HStack(spacing: 6) {
                    Rectangle()
                        .fill(Color.appInk3)
                        .frame(width: 16, height: 1)
                    Text("\(activeCategories.count) \(activeCategories.count == 1 ? "category" : "categories") active · change")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.appInk3)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.appInk3)
                }
            }
            .padding(.top, 6)
        }
    }
}
