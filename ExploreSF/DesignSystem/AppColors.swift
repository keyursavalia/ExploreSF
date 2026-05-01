import SwiftUI

// Design token: editorial travel-magazine palette matching the claude-design spec.
extension Color {
    // Paper / background
    static let appPaper         = Color(red: 246/255, green: 241/255, blue: 232/255)  // #F6F1E8
    static let appPaper2        = Color(red: 239/255, green: 231/255, blue: 215/255)  // #EFE7D7
    static let appPaper3        = Color(red: 230/255, green: 220/255, blue: 200/255)  // #E6DCC8

    // Ink / text
    static let appInk           = Color(red: 26/255,  green: 23/255,  blue: 20/255)   // #1A1714
    static let appInk2          = Color(red: 58/255,  green: 49/255,  blue: 40/255)   // #3A3128
    static let appInk3          = Color(red: 122/255, green: 111/255, blue: 96/255)   // #7A6F60
    static let appInk4          = Color(red: 184/255, green: 172/255, blue: 151/255)  // #B8AC97

    // Surfaces
    static let appCard          = Color(red: 255/255, green: 252/255, blue: 245/255)  // #FFFCF5
    static let appCardEdge      = Color(red: 26/255,  green: 23/255,  blue: 20/255).opacity(0.08)
    static let appHairline      = Color(red: 26/255,  green: 23/255,  blue: 20/255).opacity(0.10)

    // Accent — terracotta
    static let appAccent        = Color(red: 196/255, green: 90/255,  blue: 44/255)   // #C45A2C
    static let appAccentSoft    = Color(red: 246/255, green: 236/255, blue: 227/255)  // tinted wash
    static let appAccentDeep    = Color(red: 148/255, green: 60/255,  blue: 22/255)   // deep terracotta
}

// MARK: - View background helpers

extension View {
    /// Warm cream background used across all non-map screens.
    func paperBackground() -> some View {
        self.background(Color.appPaper)
    }
}
