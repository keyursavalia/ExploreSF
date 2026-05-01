import SwiftUI

struct CategoryPickerView: View {
    let isFirstRun: Bool
    let onApply: (Set<AppCategory>) -> Void
    var onClose: (() -> Void)? = nil

    @State private var vm = CategoryPickerViewModel()

    private var buttonLabel: String {
        if vm.selected.isEmpty { return "Select at least one" }
        if vm.selected.count == 1 {
            return "Show \(vm.selected.first!.displayName) on the map"
        }
        return "Show \(vm.selected.count) categories on the map"
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    if !isFirstRun, let close = onClose {
                        Button(action: close) {
                            HStack(spacing: 6) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .medium))
                                Text("Close")
                                    .font(.system(size: 13))
                            }
                            .foregroundStyle(Color.appInk)
                            .padding(.horizontal, 12)
                            .frame(height: 36)
                            .background(Color.appCard)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.appCardEdge, lineWidth: 1)
                            )
                        }
                        .padding(.bottom, 16)
                        .padding(.top, 8)
                    }

                    Text(isFirstRun ? "No. 04 — Set up" : "Categories")
                        .eyebrowStyle()

                    VStack(alignment: .leading, spacing: 0) {
                        Text("What are you")
                            .serifHeadline(size: 36, weight: .medium)
                        HStack(spacing: 0) {
                            Text("looking for?")
                                .font(.system(size: 36, weight: .regular, design: .serif))
                                .italic()
                                .foregroundStyle(Color.appInk)
                        }
                    }
                    .padding(.top, 6)

                    Text("Pick one or more. We will only show pins for the categories you choose. You can change this any time.")
                        .font(.appBody)
                        .foregroundStyle(Color.appInk2)
                        .lineSpacing(3)
                        .padding(.top, 10)
                        .padding(.bottom, 26)
                        .frame(maxWidth: 320, alignment: .leading)

                    VStack(spacing: 12) {
                        ForEach(AppCategory.allCases) { category in
                            CategoryCardView(
                                category: category,
                                isSelected: vm.isSelected(category),
                                onTap: { vm.toggle(category) }
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Coming soon")
                            .eyebrowStyle()
                            .padding(.top, 28)
                        HStack(spacing: 8) {
                            ForEach(["Museums", "Landmarks", "Viewpoints", "Food & Drink"], id: \.self) { label in
                                Text(label)
                                    .font(.system(size: 13))
                                    .italic()
                                    .foregroundStyle(Color.appInk3)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.appPaper2)
                                    .clipShape(Capsule())
                                    .opacity(0.55)
                            }
                        }
                        .flexWrap()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 70)
                .padding(.bottom, 20)
            }

            Button {
                if vm.canContinue { onApply(vm.selected) }
            } label: {
                Text(buttonLabel)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(vm.canContinue ? Color.appPaper : Color.appInk3)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(vm.canContinue ? Color.appInk : Color.appPaper2)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(!vm.canContinue)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .padding(.top, 12)
        }
        .paperBackground()
        .animation(.easeInOut(duration: 0.2), value: vm.selected)
    }
}

// MARK: - Flex wrap helper for "coming soon" chips

private extension View {
    func flexWrap() -> some View {
        self.fixedSize(horizontal: false, vertical: true)
    }
}
