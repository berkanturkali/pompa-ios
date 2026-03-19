import SwiftUI

enum PompaColors {
    enum Background {
        static let primary = Color(hex: 0x0B0E14)
        static let secondary = Color.white
    }

    enum Card {
        static let primaryBackground = Color(hex: 0x161B22)
        static let secondaryBackground = Color(hex: 0xF5C518)
    }

    enum Text {
        static let primary = Color(hex: 0xFFFFFF)
        static let secondary = Color(hex: 0x8B949E)
        static let link = Color(hex: 0x1A73E8)
    }

    enum Button {
        static let filledPrimaryBackground = Color(hex: 0x2B59FF)
        static let filledPrimaryContent = Color.white
    }

    static let border = Color(hex: 0x30363D)

    enum TopBar {
        static let background = Color(hex: 0x0B0E14)
        static let content = Color.white
    }

    enum BottomBar {
        static let background = Color(hex: 0x0B0E14)
        static let content = Color.white
        static let selectedItem = Color(hex: 0xF5C518)
        static let unselectedItem = Color.white.opacity(0.5)
        static let indicator = Color.white.opacity(0.2)
    }

    enum Chip {
        static let unselectedBackground = Color(hex: 0x161B22)
        static let selectedBackground = Color(hex: 0x0B0E14)
        static let unselectedText = Color(hex: 0x8B949E)
        static let selectedText = Color(hex: 0xF5C518)
        static let selectedBorder = Color(hex: 0xF5C518)
        static let unselectedBorder = Color(hex: 0x30363D)
    }

    enum SearchBar {
        static let background = Color(hex: 0x161B22)
        static let cursor = Color.white
        static let text = Color.white
        static let startIcon = Color(hex: 0x8B949E)
        static let closeIcon = Color.white
        static let hint = Color(hex: 0x8B949E)
    }

    enum PullToRefresh {
        static let container = Color(hex: 0x0B0E14)
        static let content = Color.white
    }
}

private extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}
