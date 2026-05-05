import SwiftUI

struct ItineraryAnnotationView: View {
    let number: Int
    let category: AppCategory
    let isCompleted: Bool

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(isCompleted ? Color.appInk3 : category.color)
                    .frame(width: 34, height: 34)
                    .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 2)
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                } else {
                    Text("\(number)")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            ItineraryPinTriangle()
                .fill(isCompleted ? Color.appInk3 : category.color)
                .frame(width: 12, height: 7)
        }
        .animation(.easeInOut(duration: 0.2), value: isCompleted)
    }
}

private struct ItineraryPinTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
