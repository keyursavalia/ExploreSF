import SwiftUI

enum AppCategory: String, CaseIterable, Identifiable, Hashable, Codable {
    case film          = "film"
    case popos         = "popos"
    case park          = "park"
    case art           = "art"
    case entertainment = "entertainment"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .film:          return "Film Locations"
        case .popos:         return "Public Open Spaces"
        case .park:          return "Parks & Recreation"
        case .art:           return "Art"
        case .entertainment: return "Entertainment"
        }
    }

    var tagline: String {
        switch self {
        case .film:          return "Where the camera rolled"
        case .popos:         return "Plazas, atriums & hidden gardens"
        case .park:          return "Open spaces and nature"
        case .art:           return "Sculptures, murals & installations"
        case .entertainment: return "Venues, stages & nightlife"
        }
    }

    var color: Color {
        switch self {
        case .film:          return Color(red: 196/255, green: 90/255,  blue: 44/255)   // terracotta
        case .popos:         return Color(red: 74/255,  green: 127/255, blue: 160/255)  // SF bay slate
        case .park:          return Color(red: 92/255,  green: 126/255, blue: 54/255)   // botanical green
        case .art:           return Color(red: 130/255, green: 85/255,  blue: 160/255)  // warm violet
        case .entertainment: return Color(red: 200/255, green: 140/255, blue: 30/255)   // amber
        }
    }

    var systemIcon: String {
        switch self {
        case .film:          return "film"
        case .popos:         return "building.columns"
        case .park:          return "tree"
        case .art:           return "photo.artframe"
        case .entertainment: return "ticket"
        }
    }
}
