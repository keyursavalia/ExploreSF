import SwiftUI

struct ItineraryStopRowView: View {
    let stop: ItineraryStop
    let onToggleComplete: () -> Void
    let onNavigate: () -> Void

    private var category: AppCategory { stop.category ?? .film }

    var body: some View {
        HStack(spacing: 14) {
            numberBadge
            info
            Spacer(minLength: 0)
            doneToggle
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
        .opacity(stop.isCompleted ? 0.55 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: stop.isCompleted)
    }

    private var numberBadge: some View {
        ZStack {
            Circle()
                .fill(stop.isCompleted ? Color.appInk4 : category.color)
                .frame(width: 32, height: 32)
            if stop.isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            } else {
                Text("\(stop.orderInDay + 1)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: stop.isCompleted)
    }

    private var info: some View {
        Button(action: onNavigate) {
            VStack(alignment: .leading, spacing: 3) {
                Text(stop.displayName)
                    .font(.system(size: 16, weight: .medium, design: .serif))
                    .foregroundStyle(Color.appInk)
                    .lineLimit(2)
                    .strikethrough(stop.isCompleted, color: Color.appInk3)
                if !stop.locationName.isEmpty {
                    Label(stop.locationName, systemImage: "mappin")
                        .font(.appCaption)
                        .foregroundStyle(Color.appInk4)
                        .lineLimit(1)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var doneToggle: some View {
        Button(action: onToggleComplete) {
            Image(systemName: stop.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 22))
                .foregroundStyle(stop.isCompleted ? category.color : Color.appInk4)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: stop.isCompleted)
    }
}
