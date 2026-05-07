import SwiftUI

struct UtilityToggleButtonsView: View {
    @Binding var showBathrooms: Bool
    @Binding var showWaterFountains: Bool

    static let bathroomColor  = Color(red: 60/255,  green: 143/255, blue: 210/255)
    static let fountainColor   = Color(red: 32/255,  green: 160/255, blue: 175/255)

    var body: some View {
        VStack(spacing: 8) {
            toggleButton(
                icon: "toilet",
                isOn: showBathrooms,
                activeColor: Self.bathroomColor
            ) {
                withAnimation(.easeInOut(duration: 0.2)) { showBathrooms.toggle() }
            }
            toggleButton(
                icon: "drop.fill",
                isOn: showWaterFountains,
                activeColor: Self.fountainColor
            ) {
                withAnimation(.easeInOut(duration: 0.2)) { showWaterFountains.toggle() }
            }
        }
    }

    private func toggleButton(
        icon: String,
        isOn: Bool,
        activeColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isOn ? activeColor : Color.appCard)
                    .frame(width: 44, height: 44)
                    .overlay(Circle().stroke(isOn ? activeColor : Color.appCardEdge, lineWidth: 1))
                    .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isOn ? Color.appPaper : Color.appInk)
            }
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isOn)
    }
}
