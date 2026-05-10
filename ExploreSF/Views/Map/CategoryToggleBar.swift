import SwiftUI

struct CategoryToggleBar: View {
    let activeCategories: Set<AppCategory>
    @Binding var isExpanded: Bool
    let onApply: (Set<AppCategory>) -> Void

    @State private var pending: Set<AppCategory> = []

    var body: some View {
        VStack(spacing: 0) {
            if isExpanded {
                categoryChips
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            toggleButton
        }
        .padding(.horizontal, 16)
        .onChange(of: isExpanded) { _, expanded in
            if expanded { pending = activeCategories }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isExpanded)
    }

    private var toggleButton: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 13, weight: .semibold))
                Text(isExpanded ? "Done" : "Categories")
                    .font(.system(size: 13, weight: .semibold))
                if !isExpanded {
                    HStack(spacing: 4) {
                        ForEach(AppCategory.allCases) { cat in
                            if activeCategories.contains(cat) {
                                Circle()
                                    .fill(cat.color)
                                    .frame(width: 7, height: 7)
                            }
                        }
                    }
                }
            }
            .foregroundStyle(Color.appInk)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(AppCategory.allCases) { cat in
                let on = pending.contains(cat)
                Button {
                    if on {
                        if pending.count > 1 { pending.remove(cat) }
                    } else {
                        pending.insert(cat)
                    }
                    onApply(pending)
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: cat.systemIcon)
                            .font(.system(size: 12, weight: .medium))
                        Text(cat.displayName.components(separatedBy: " ").first ?? cat.displayName)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundStyle(on ? Color.appPaper : Color.appInk2)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(on ? cat.color : Color.appCard.opacity(0.95))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(on ? cat.color : Color.appCardEdge, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
                .animation(.easeInOut(duration: 0.15), value: on)
            }
          }
          .padding(.horizontal, 4)
        }
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
        .padding(.bottom, 8)
    }
}
