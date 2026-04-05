import Foundation
import SwiftUI
import Combine

struct PompaUserPreferencesState {
    let selectedCity: (String?, String?)
    let favoriteProvider: (String?, String?)
}

@MainActor
final class PompaUserPrefs: ObservableObject {
    static let shared = PompaUserPrefs()

    private enum Keys {
        static let selectedCityName = "selected_city_name"
        static let selectedCityCode = "selected_city_code"
        static let favoriteFuelProviderID = "favorite_fuel_provider_id"
        static let favoriteFuelProviderName = "favorite_fuel_provider_name"
        static let favoriteFuelProviderLogo = "favorite_fuel_provider_logo"
    }

    @Published private(set) var userPreferences: PompaUserPreferencesState

    private let defaults = UserDefaults.standard

    private init() {
        userPreferences = PompaUserPreferencesState(
            selectedCity: (
                defaults.string(forKey: Keys.selectedCityCode),
                defaults.string(forKey: Keys.selectedCityName)
            ),
            favoriteProvider: (
                defaults.string(forKey: Keys.favoriteFuelProviderLogo),
                defaults.string(forKey: Keys.favoriteFuelProviderName)
            )
        )
    }

    func setSelectedCity(cityCode: String, cityName: String) async {
        defaults.set(cityCode, forKey: Keys.selectedCityCode)
        defaults.set(cityName, forKey: Keys.selectedCityName)
        refreshState()
    }

    func setSelectedProvider(providerName: String, providerLogo: String?) async {
        defaults.set(providerName, forKey: Keys.favoriteFuelProviderName)
        defaults.set(providerLogo, forKey: Keys.favoriteFuelProviderLogo)
        refreshState()
    }

    func setSelectedProvider(
        providerID: Int,
        providerName: String,
        providerLogo: String?
    ) async {
        defaults.set(providerID, forKey: Keys.favoriteFuelProviderID)
        defaults.set(providerName, forKey: Keys.favoriteFuelProviderName)
        defaults.set(providerLogo, forKey: Keys.favoriteFuelProviderLogo)
        refreshState()
    }

    func getSelectedCity() async -> (String?, String?) {
        (
            defaults.string(forKey: Keys.selectedCityCode),
            defaults.string(forKey: Keys.selectedCityName)
        )
    }

    func getSelectedProvider() async -> (String?, String?) {
        (
            defaults.string(forKey: Keys.favoriteFuelProviderLogo),
            defaults.string(forKey: Keys.favoriteFuelProviderName)
        )
    }

    func getSelectedProviderID() -> Int? {
        defaults.object(forKey: Keys.favoriteFuelProviderID) as? Int
    }

    private func refreshState() {
        userPreferences = PompaUserPreferencesState(
            selectedCity: (
                defaults.string(forKey: Keys.selectedCityCode),
                defaults.string(forKey: Keys.selectedCityName)
            ),
            favoriteProvider: (
                defaults.string(forKey: Keys.favoriteFuelProviderLogo),
                defaults.string(forKey: Keys.favoriteFuelProviderName)
            )
        )
    }
}
