import SwiftUI

enum AppCategory: String, CaseIterable, Identifiable, Hashable, Codable {
    case film  = "film"
    case popos = "popos"
    case park  = "park"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .film:  return "Film Locations"
        case .popos: return "Public Open Spaces"
        case .park:  return "Parks & Recreation"
        }
    }

    var tagline: String {
        switch self {
        case .film:  return "Where the camera rolled"
        case .popos: return "Plazas, atriums & hidden gardens"
        case .park:  return "Open spaces and nature"
        }
    }

    var itemCount: String {
        switch self {
        case .film:  return "299 locations"
        case .popos: return "81 spaces"
        case .park:  return "220 properties"
        }
    }

    var color: Color {
        switch self {
        case .film:  return Color(red: 196/255, green: 90/255,  blue: 44/255)   // terracotta
        case .popos: return Color(red: 74/255,  green: 127/255, blue: 160/255)  // SF bay slate
        case .park:  return Color(red: 92/255,  green: 126/255, blue: 54/255)   // botanical green
        }
    }

    var systemIcon: String {
        switch self {
        case .film:  return "film"
        case .popos: return "building.columns"
        case .park:  return "tree"
        }
    }
}
