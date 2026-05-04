import SwiftUI
import SwiftData

struct BookmarkButton: View {
    let pin: PlacePin
    @Query private var saved: [SavedPlace]
    @Environment(\.modelContext) private var modelContext

    private var savedID: String { "\(pin.category.rawValue):\(pin.id)" }
    private var isSaved: Bool { saved.contains { $0.id == savedID } }

    var body: some View {
        Button(action: toggle) {
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(isSaved ? pin.category.color : Color.appInk3)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSaved)
    }

    private func toggle() {
        if isSaved {
            if let existing = saved.first(where: { $0.id == savedID }) {
                modelContext.delete(existing)
            }
        } else {
            modelContext.insert(SavedPlace(pin: pin))
        }
        try? modelContext.save()
    }
}
