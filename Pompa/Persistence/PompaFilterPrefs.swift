import Combine
import Foundation

struct PompaFilterPreferencesState {
    let sortDirection: Int
    let fuelType: Int
}

@MainActor
final class PompaFilterPrefs: ObservableObject {
    static let shared = PompaFilterPrefs()

    private enum Keys {
        static let sortDirection = "sort_direction"
        static let fuelType = "fuel_type"
    }

    @Published private(set) var filterPreferences: PompaFilterPreferencesState

    private let defaults = UserDefaults.standard

    private init() {
        filterPreferences = PompaFilterPreferencesState(
            sortDirection: defaults.object(forKey: Keys.sortDirection) as? Int ?? 0,
            fuelType: defaults.object(forKey: Keys.fuelType) as? Int ?? 0
        )
    }

    func setSortDirection(_ sortDirection: Int) async {
        defaults.set(sortDirection, forKey: Keys.sortDirection)
        refreshState()
    }

    func setSelectedFuelType(_ fuelType: Int) async {
        defaults.set(fuelType, forKey: Keys.fuelType)
        refreshState()
    }

    private func refreshState() {
        filterPreferences = PompaFilterPreferencesState(
            sortDirection: defaults.object(forKey: Keys.sortDirection) as? Int ?? 0,
            fuelType: defaults.object(forKey: Keys.fuelType) as? Int ?? 0
        )
    }
}
