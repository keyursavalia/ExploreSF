import SwiftUI

struct CategoryCardView: View {
    let category: AppCategory
    let isSelected: Bool
    let onTap: () -> Void

    private var tagline: String {
        switch category {
        case .film:  return "Movie & TV locations"
        case .popos: return "Public open spaces"
        case .park:  return "Rec & Parks properties"
        case .art:   return "Public Arts"
        }
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                iconBox
                labelStack
                Spacer()
                checkCircle
            }
            .padding(18)
            .background(isSelected ? Color.appInk : Color.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Color.appInk : Color.appCardEdge, lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
    }

    private var iconBox: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? Color.white.opacity(0.08) : category.color)
                .frame(width: 52, height: 52)
            Image(systemName: category.systemIcon)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(isSelected ? category.color : Color.white)
        }
    }

    private var labelStack: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(category.displayName)
                .font(.system(size: 22, weight: .medium, design: .serif))
                .foregroundStyle(isSelected ? Color.appPaper : Color.appInk)
                .lineLimit(1)
            Text(tagline)
                .font(.system(size: 13))
                .foregroundStyle(isSelected ? Color.appPaper.opacity(0.7) : Color.appInk3)
        }
    }

    private var checkCircle: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Color.appPaper : Color.appInk4, lineWidth: 1.5)
                .frame(width: 26, height: 26)
            if isSelected {
                Circle()
                    .fill(Color.appPaper)
                    .frame(width: 26, height: 26)
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.appInk)
            }
        }
    }
}
