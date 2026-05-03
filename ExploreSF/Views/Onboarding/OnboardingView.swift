import SwiftUI

struct OnboardingView: View {
    @State private var vm = OnboardingViewModel()
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: Binding(
                get: { vm.currentPage },
                set: { vm.currentPage = $0 }
            )) {
                ForEach(0..<OnboardingPanel.all.count, id: \.self) { i in
                    ScrollView {
                        OnboardingPanelView(panel: OnboardingPanel.all[i])
                            .padding(.horizontal, 24)
                            .padding(.top, 18)
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: vm.currentPage)

            progressDots
                .padding(.vertical, 12)

            actionButtons
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
        }
        .paperBackground()
    }

    private var progressDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<OnboardingPanel.all.count, id: \.self) { i in
                RoundedRectangle(cornerRadius: 6)
                    .fill(i == vm.currentPage ? Color.appInk : Color.appInk4)
                    .frame(width: i == vm.currentPage ? 22 : 6, height: 6)
                    .animation(.easeInOut(duration: 0.3), value: vm.currentPage)
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 10) {
            if vm.currentPage > 0 {
                Button {
                    withAnimation { vm.currentPage -= 1 }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.appInk)
                        .frame(width: 52, height: 52)
                        .background(Color.appCard)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.appCardEdge, lineWidth: 1)
                        )
                }
                .transition(.opacity.combined(with: .scale))
            }

            Button {
                withAnimation {
                    if vm.isLastPage {
                        onComplete()
                    } else {
                        vm.advance()
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Text(vm.isLastPage ? "Get started" : "Continue")
                        .font(.system(size: 16, weight: .semibold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(Color.appPaper)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.appInk)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: vm.currentPage)
    }
}
