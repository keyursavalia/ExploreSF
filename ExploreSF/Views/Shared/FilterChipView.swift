import SwiftUI

struct FilterChipView: View {
    let label:    String
    let isActive: Bool
    let onTap:    () -> Void
    let onRemove: (() -> Void)?

    init(label: String, isActive: Bool, onTap: @escaping () -> Void, onRemove: (() -> Void)? = nil) {
        self.label    = label
        self.isActive = isActive
        self.onTap    = onTap
        self.onRemove = onRemove
    }

    var body: some View {
        HStack(spacing: 4) {
            Button(action: onTap) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(isActive ? .white : .primary)
            }

            if isActive, let onRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.8))
                }
            } else if !isActive {
                Image(systemName: "chevron.down")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(isActive ? Color.accentColor : Color(.systemGray6), in: Capsule())
    }
}
