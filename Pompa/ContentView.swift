//

import SwiftUI

struct ContentView: View {
    @StateObject private var pompaUserPrefs = PompaUserPrefs.shared
    @State private var route: AppRoute = .provinces
    private let topLevelDestinations = BottomNavDestination.allCases

    var body: some View {
        ZStack {
            PompaColors.Background.primary
                .ignoresSafeArea()

            VStack(spacing: 0) {
                PompaAppTopBar(
                    showBackButton: route.showsBackButton,
                    showSelectedProvince: route.showsSelectedProvince,
                    title: route.title,
                    provinceName: selectedProvinceName,
                    provinceCode: selectedProvinceCode,
                    onBackButtonClick: handleBack,
                    onSelectedProvinceClick: {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.86)) {
                            route = .provinces
                        }
                    }
                )

                currentScreen

                if route.showsBottomBar {
                    PompaAppBottomBar(
                        destinations: topLevelDestinations,
                        selectedDestination: route.bottomNavDestination ?? .home,
                        onDestinationSelected: handleBottomDestinationSelection
                    )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .animation(.spring(response: 0.28, dampingFraction: 0.86), value: route)
        .onAppear {
            syncRouteWithPreferences()
        }
        .onReceive(pompaUserPrefs.$userPreferences) { _ in
            if pompaUserPrefs.hasSelectedProvinceAndFavoriteProvider() {
                route = .home
            }
        }
    }
}

private extension ContentView {
    @ViewBuilder
    var currentScreen: some View {
        switch route {
        case .provinces:
            ProvincesScreen { province in
                route = .providers(province)
            }
        case .providers:
            ProvidersScreen {
                route = .home
            }
        case .home:
            HomeScreen()
        case .settings:
            Text(LocalizedStrings.settingsTitle)
        }
    }

    var selectedProvinceCode: String {
        pompaUserPrefs.userPreferences.selectedCity.0 ?? ""
    }

    var selectedProvinceName: String {
        pompaUserPrefs.userPreferences.selectedCity.1 ?? ""
    }

    func handleBack() {
        switch route {
        case .providers:
            route = .provinces
        case .provinces, .home, .settings:
            break
        }
    }

    func syncRouteWithPreferences() {
        route = pompaUserPrefs.hasSelectedProvinceAndFavoriteProvider() ? .home : .provinces
    }

    func handleBottomDestinationSelection(_ destination: BottomNavDestination) {
        switch destination {
        case .home:
            route = .home
        case .settings:
            route = .settings
        }
    }
}

private enum AppRoute: Equatable {
    case provinces
    case providers(Province)
    case home
    case settings

    var title: String {
        switch self {
        case .provinces:
            return LocalizedStrings.provincesSelectTitle
        case .providers:
            return LocalizedStrings.providersSelectTitle
        case .home:
            return LocalizedStrings.appName
        case .settings:
            return LocalizedStrings.settingsTitle
        }
    }

    var showsBackButton: Bool {
        switch self {
        case .providers:
            return true
        case .provinces, .home, .settings:
            return false
        }
    }

    var showsSelectedProvince: Bool {
        switch self {
        case .providers, .home, .settings:
            return true
        case .provinces:
            return false
        }
    }

    var showsBottomBar: Bool {
        switch self {
        case .home, .settings:
            return true
        case .providers, .provinces:
            return false
        }
    }

    var bottomNavDestination: BottomNavDestination? {
        switch self {
        case .home:
            return .home
        case .settings:
            return .settings
        case .provinces, .providers:
            return nil
        }
    }
}

#Preview {
    ContentView()
}
