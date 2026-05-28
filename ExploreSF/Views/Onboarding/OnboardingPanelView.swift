import SwiftUI

enum OnboardingVisual {
    case photo(String)
    case categoryGrid
    case itineraryRoute
}

struct OnboardingPanel {
    let eyebrow: String
    let title: String
    let titleEmphasis: String
    let body: String
    let tintColor: Color
    let visual: OnboardingVisual
}

extension OnboardingPanel {
    static let all: [OnboardingPanel] = [
        OnboardingPanel(
            eyebrow: "No. 01 — Welcome",
            title: "San Francisco,",
            titleEmphasis: "curated.",
            body: "A guidebook in your pocket. Films shot on these streets, parks worth a Sunday, and the public art hiding in plain sight.",
            tintColor: Color(red: 0.53, green: 0.65, blue: 0.45),
            visual: .photo("onboarding_golden_gate")
        ),
        OnboardingPanel(
            eyebrow: "No. 02 — How it works",
            title: "Pick what you",
            titleEmphasis: "want to see.",
            body: "Choose one or more categories — film locations, parks, public art. The map shows only what you asked for. Switch any time.",
            tintColor: Color(red: 0.35, green: 0.52, blue: 0.68),
            visual: .categoryGrid
        ),
        OnboardingPanel(
            eyebrow: "No. 03 — Make it yours",
            title: "Save places,",
            titleEmphasis: "build a day.",
            body: "Bookmark places to come back to. Drop a few into a Trip and we will order them into a walkable route.",
            tintColor: Color(red: 0.78, green: 0.62, blue: 0.25),
            visual: .itineraryRoute
        ),
    ]
}

struct OnboardingPanelView: View {
    let panel: OnboardingPanel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            visualCard
                .frame(maxWidth: .infinity, minHeight: 280, maxHeight: 280)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 20))

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

    @ViewBuilder
    private var visualCard: some View {
        switch panel.visual {
        case .photo(let name):
            Image(name)
                .resizable()
                .scaledToFill()
        case .categoryGrid:
            CategoryGridIllustration(tintColor: panel.tintColor)
        case .itineraryRoute:
            ItineraryRouteIllustration(tintColor: panel.tintColor)
        }
    }
}

// MARK: - Panel 2: Category grid illustration

private struct CategoryGridIllustration: View {
    let tintColor: Color

    private let categories: [(icon: String, label: String, color: Color)] = [
        ("film",          "Film",  Color(red: 0.72, green: 0.35, blue: 0.30)),
        ("building.2",    "POPOS", Color(red: 0.35, green: 0.52, blue: 0.68)),
        ("tree",          "Parks", Color(red: 0.40, green: 0.62, blue: 0.38)),
        ("paintpalette",  "Art",   Color(red: 0.68, green: 0.48, blue: 0.72)),
    ]

    var body: some View {
        ZStack {
            tintColor.opacity(0.12)

            // Subtle grid lines
            Canvas { ctx, size in
                let cols = 6
                let rows = 5
                let cw = size.width / CGFloat(cols)
                let rh = size.height / CGFloat(rows)
                var path = Path()
                for c in 1..<cols {
                    path.move(to: CGPoint(x: cw * CGFloat(c), y: 0))
                    path.addLine(to: CGPoint(x: cw * CGFloat(c), y: size.height))
                }
                for r in 1..<rows {
                    path.move(to: CGPoint(x: 0, y: rh * CGFloat(r)))
                    path.addLine(to: CGPoint(x: size.width, y: rh * CGFloat(r)))
                }
                ctx.stroke(path, with: .color(Color.white.opacity(0.25)), lineWidth: 0.5)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(0..<4, id: \.self) { i in
                    let cat = categories[i]
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(cat.color.opacity(0.18))
                                .frame(width: 52, height: 52)
                            Image(systemName: cat.icon)
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(cat.color)
                        }
                        Text(cat.label)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.appInk)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.72))
                            .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
                    )
                }
            }
            .padding(24)
        }
    }
}

// MARK: - Panel 3: Itinerary route illustration

private struct ItineraryRouteIllustration: View {
    let tintColor: Color

    private let stops: [(num: Int, name: String, detail: String)] = [
        (1, "Dolores Park",       "0.4 mi"),
        (2, "Clarion Alley",      "0.6 mi"),
        (3, "SFMOMA Sculpture",   "1.1 mi"),
    ]

    var body: some View {
        ZStack {
            tintColor.opacity(0.12)

            VStack(spacing: 0) {
                // Day header chip
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 11, weight: .semibold))
                    Text("Day 1  —  3 stops")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(tintColor)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule().fill(tintColor.opacity(0.18))
                )
                .padding(.top, 28)

                Spacer()

                // Stop rows
                VStack(spacing: 0) {
                    ForEach(0..<stops.count, id: \.self) { i in
                        HStack(spacing: 12) {
                            // Number badge + connector line
                            VStack(spacing: 0) {
                                ZStack {
                                    Circle()
                                        .fill(tintColor)
                                        .frame(width: 28, height: 28)
                                    Text("\(stops[i].num)")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundStyle(.white)
                                }
                                if i < stops.count - 1 {
                                    Rectangle()
                                        .fill(tintColor.opacity(0.35))
                                        .frame(width: 2, height: 28)
                                }
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(stops[i].name)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color.appInk)
                                if i < stops.count - 1 {
                                    HStack(spacing: 3) {
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 9, weight: .medium))
                                        Text(stops[i].detail)
                                            .font(.system(size: 11, weight: .regular))
                                    }
                                    .foregroundStyle(Color.appInk3)
                                }
                            }

                            Spacer()

                            Image(systemName: "bookmark.fill")
                                .font(.system(size: 13))
                                .foregroundStyle(tintColor.opacity(0.7))
                        }
                        .padding(.vertical, i < stops.count - 1 ? 0 : 4)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 28)
            }
        }
    }
}
