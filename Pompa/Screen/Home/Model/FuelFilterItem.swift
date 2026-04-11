import Foundation

struct FuelFilterItem: Identifiable, Equatable {
    let value: String
    let icon: String
    let selected: Bool
    let type: FuelType

    var id: Int {
        type.value
    }

    init(value: String, icon: String, selected: Bool = false, type: FuelType) {
        self.value = value
        self.icon = icon
        self.selected = selected
        self.type = type
    }
}

enum FuelType: Int, CaseIterable {
    case all = 0
    case gasoline = 1
    case diesel = 2
    case lpg = 3

    var value: Int {
        rawValue
    }
}

enum FuelFilterDataSource {
    static func getFilters() -> [FuelFilterItem] {
        FuelType.allCases.map { type in
            FuelFilterItem(
                value: type.title,
                icon: type.iconSystemName,
                selected: false,
                type: type
            )
        }
    }
}

private extension FuelType {
    var title: String {
        switch self {
        case .all:
            return LocalizedStrings.fuelFilterAll
        case .gasoline:
            return LocalizedStrings.fuelFilterGasoline
        case .diesel:
            return LocalizedStrings.fuelFilterDiesel
        case .lpg:
            return LocalizedStrings.fuelFilterLPG
        }
    }

    var iconSystemName: String {
        switch self {
        case .all:
            return "square.grid.2x2"
        case .gasoline:
            return "fuelpump"
        case .diesel:
            return "fuelpump.fill"
        case .lpg:
            return "flame"
        }
    }
}
