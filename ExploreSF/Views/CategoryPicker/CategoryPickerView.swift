import SwiftUI

struct CategoryPickerView: View {
    let isFirstRun:        Bool
    let initialCategories: Set<AppCategory>
    let onApply:           (Set<AppCategory>) -> Void

    @State private var vm = CategoryPickerViewModel()

    init(isFirstRun: Bool, initialCategories: Set<AppCategory> = [], onApply: @escaping (Set<AppCategory>) -> Void) {
        self.isFirstRun        = isFirstRun
        self.initialCategories = initialCategories
        self.onApply           = onApply
    }

    private var buttonLabel: String {
        if vm.selected.isEmpty { return "Select at least one" }
        if isFirstRun {
            if vm.selected.count == 1 {
                return "Show \(vm.selected.first!.displayName) on the map"
            }
            return "Show \(vm.selected.count) categories on the map"
        } else {
            if vm.selected.count == 1 {
                return "Apply \(vm.selected.first!.displayName)"
            }
            return "Apply \(vm.selected.count) categories"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
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
                                category:   category,
                                isSelected: vm.isSelected(category),
                                onTap:      { vm.toggle(category) }
                            )
                        }
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
        .onAppear {
            if !initialCategories.isEmpty { vm.selected = initialCategories }
        }
    }
}
