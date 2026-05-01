import SwiftUI

struct OnboardingPanel {
    let eyebrow: String
    let title: String
    let titleEmphasis: String
    let body: String
    let tintColor: Color
}

extension OnboardingPanel {
    static let all: [OnboardingPanel] = [
        OnboardingPanel(
            eyebrow: "No. 01 — Welcome",
            title: "San Francisco,",
            titleEmphasis: "curated.",
            body: "A guidebook in your pocket. Films shot on these streets, parks worth a Sunday, and the public art hiding in plain sight.",
            tintColor: Color(red: 0.53, green: 0.65, blue: 0.45)
        ),
        OnboardingPanel(
            eyebrow: "No. 02 — How it works",
            title: "Pick what you",
            titleEmphasis: "want to see.",
            body: "Choose one or more categories — film locations, parks, public art. The map shows only what you asked for. Switch any time.",
            tintColor: Color(red: 0.35, green: 0.52, blue: 0.68)
        ),
        OnboardingPanel(
            eyebrow: "No. 03 — Make it yours",
            title: "Save places,",
            titleEmphasis: "build a day.",
            body: "Bookmark places to come back to. Drop a few into a Trip and we will order them into a walkable route.",
            tintColor: Color(red: 0.78, green: 0.62, blue: 0.25)
        ),
    ]
}

struct OnboardingPanelView: View {
    let panel: OnboardingPanel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RoundedRectangle(cornerRadius: 20)
                .fill(panel.tintColor.opacity(0.25))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [panel.tintColor.opacity(0.5), panel.tintColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .frame(height: 280)

            Text(panel.eyebrow)
                .eyebrowStyle()
                .padding(.top, 28)

            VStack(alignment: .leading, spacing: 0) {
                Text(panel.title)
                    .serifHeadline(size: 44, weight: .medium)
                    .lineSpacing(2)
                Text(panel.titleEmphasis)
                    .font(.system(size: 44, weight: .regular, design: .serif))
                    .italic()
                    .foregroundStyle(Color.appInk)
            }
            .padding(.top, 10)

            Text(panel.body)
                .font(.appBody)
                .foregroundStyle(Color.appInk2)
                .lineSpacing(4)
                .padding(.top, 14)
                .frame(maxWidth: 320, alignment: .leading)
        }
    }
}
