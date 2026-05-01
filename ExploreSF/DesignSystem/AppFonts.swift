import SwiftUI

// Design token: editorial typography matching the claude-design spec.
// Serif headlines use .fontDesign(.serif) → New York on iOS (closest to Cormorant Garamond).
// Eyebrow labels are uppercase SF Pro with wide letter-spacing.

extension Font {
    // MARK: - Serif (editorial headlines)
    static func serifTitle(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    // MARK: - Sans (UI labels, body)
    static var appMeta:    Font { .system(size: 13, weight: .regular) }
    static var appCaption: Font { .system(size: 12, weight: .regular) }
    static var appBody:    Font { .system(size: 15, weight: .regular) }
}

// MARK: - Text style modifiers

struct EyebrowStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 11, weight: .semibold))
            .tracking(2.2)
            .textCase(.uppercase)
            .foregroundStyle(Color.appInk3)
    }
}

struct SerifHeadlineStyle: ViewModifier {
    let size: CGFloat
    let weight: Font.Weight

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: .serif))
            .foregroundStyle(Color.appInk)
    }
}

extension View {
    func eyebrowStyle()  -> some View { modifier(EyebrowStyle()) }

    func serifHeadline(size: CGFloat, weight: Font.Weight = .medium) -> some View {
        modifier(SerifHeadlineStyle(size: size, weight: weight))
    }
}
