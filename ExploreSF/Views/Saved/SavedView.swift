import SwiftUI

struct SavedView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bookmark")
                .font(.system(size: 40))
                .foregroundStyle(Color.appInk4)

            Text("Saved Places")
                .font(.system(size: 28, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)

            Text("Places you bookmark will appear here.")
                .font(.appBody)
                .foregroundStyle(Color.appInk3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .paperBackground()
    }
}
