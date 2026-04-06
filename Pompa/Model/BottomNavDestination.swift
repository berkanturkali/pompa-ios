import Foundation

enum BottomNavDestination: String, CaseIterable, Identifiable {
    case home
    case settings

    var id: String { rawValue }

    var iconSystemName: String {
        switch self {
        case .home:
            return "house"
        case .settings:
            return "gearshape"
        }
    }

    var title: String {
        switch self {
        case .home:
            return LocalizedStrings.homeTitle
        case .settings:
            return LocalizedStrings.settingsTitle
        }
    }

    var scrollable: Bool {
        switch self {
        case .home:
            return true
        case .settings:
            return false
        }
    }
}
