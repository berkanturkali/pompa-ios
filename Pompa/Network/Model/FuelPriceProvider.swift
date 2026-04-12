import Foundation

struct FuelPriceProvider: Codable {
    let provider: String
    let providerLogo: String
    let providerIsManual: Bool
    let averagePrice: Double?
    let ok: Bool
    let source: PriceSource?
    let data: [FuelPriceRecord?]
    let error: String?

    func copy(data: [FuelPriceRecord?]) -> FuelPriceProvider {
        FuelPriceProvider(
            provider: provider,
            providerLogo: providerLogo,
            providerIsManual: providerIsManual,
            averagePrice: averagePrice,
            ok: ok,
            source: source,
            data: data,
            error: error
        )
    }
}

enum PriceSource: String, Codable {
    case provider
    case database
}

struct FuelPriceRecord: Codable {
    let brand: String?
    let cityCode: String?
    let cityName: String?
    let districtName: String?
    let prices: FuelPrices?
    let unit: String?
    let weightUnit: String?
    let source: String?
    let fetchedAt: String?
    let priceTrends: [PriceTrend]?

    private enum CodingKeys: String, CodingKey {
        case brand
        case cityCode
        case cityName
        case districtName
        case prices
        case unit
        case weightUnit
        case source
        case fetchedAt
        case priceTrends
    }

    init(
        brand: String?,
        cityCode: String?,
        cityName: String?,
        districtName: String?,
        prices: FuelPrices?,
        unit: String?,
        weightUnit: String?,
        source: String?,
        fetchedAt: String?,
        priceTrends: [PriceTrend]?
    ) {
        self.brand = brand
        self.cityCode = cityCode
        self.cityName = cityName
        self.districtName = districtName
        self.prices = prices
        self.unit = unit
        self.weightUnit = weightUnit
        self.source = source
        self.fetchedAt = fetchedAt
        self.priceTrends = priceTrends
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        brand = try container.decodeIfPresent(String.self, forKey: .brand)
        cityCode = try container.decodeFlexibleStringIfPresent(forKey: .cityCode)
        cityName = try container.decodeIfPresent(String.self, forKey: .cityName)
        districtName = try container.decodeIfPresent(String.self, forKey: .districtName)
        prices = try container.decodeIfPresent(FuelPrices.self, forKey: .prices)
        unit = try container.decodeIfPresent(String.self, forKey: .unit)
        weightUnit = try container.decodeIfPresent(String.self, forKey: .weightUnit)
        source = try container.decodeIfPresent(String.self, forKey: .source)
        fetchedAt = try container.decodeIfPresent(String.self, forKey: .fetchedAt)
        priceTrends = try container.decodeIfPresent([PriceTrend].self, forKey: .priceTrends)
    }
}

struct FuelPrices: Codable {
    let gasoline95: Double?
    let gasoline95Premium: Double?
    let diesel: Double?
    let dieselPremium: Double?
    let kerosene: Double?
    let heatingOil: Double?
    let fuelOil: Double?
    let fuelOilHighSulfur: Double?
    let autogas: Double?

    func mapToUiItems(unit: String, weightUnit: String) -> [FuelPriceUiModel] {
        var items: [FuelPriceUiModel] = []

        if let value = toText(gasoline95) {
            items.append(FuelPriceUiModel(title: .gasoline95, price: value, unit: unit))
        }
        if let value = toText(gasoline95Premium) {
            items.append(FuelPriceUiModel(title: .gasoline95Premium, price: value, unit: unit))
        }
        if let value = toText(diesel) {
            items.append(FuelPriceUiModel(title: .diesel, price: value, unit: unit))
        }
        if let value = toText(dieselPremium) {
            items.append(FuelPriceUiModel(title: .dieselPremium, price: value, unit: unit))
        }
        if let value = toText(kerosene) {
            items.append(FuelPriceUiModel(title: .kerosene, price: value, unit: unit))
        }
        if let value = toText(heatingOil) {
            items.append(FuelPriceUiModel(title: .heatingOil, price: value, unit: weightUnit))
        }
        if let value = toText(fuelOil) {
            items.append(FuelPriceUiModel(title: .fuelOil, price: value, unit: weightUnit))
        }
        if let value = toText(fuelOilHighSulfur) {
            items.append(FuelPriceUiModel(title: .fuelOilHighSulfur, price: value, unit: weightUnit))
        }
        if let value = toText(autogas) {
            items.append(FuelPriceUiModel(title: .autogas, price: value, unit: unit))
        }

        return items
    }

    func notNullCount() -> Int {
        [
            gasoline95,
            gasoline95Premium,
            diesel,
            dieselPremium,
            kerosene,
            heatingOil,
            fuelOil,
            fuelOilHighSulfur,
            autogas
        ].compactMap { $0 }.count
    }

    private func toText(_ value: Double?) -> String? {
        value.map { String(format: "%.2f", $0) }
    }
}

struct FuelPriceUiModel: Identifiable, Equatable {
    let title: FuelPriceTitle
    let price: String
    let unit: String

    var id: String {
        "\(title.rawValue)-\(price)-\(unit)"
    }
}

enum FuelPriceTitle: String, Equatable {
    case gasoline95
    case gasoline95Premium
    case diesel
    case dieselPremium
    case kerosene
    case heatingOil
    case fuelOil
    case fuelOilHighSulfur
    case autogas

    var localized: String {
        switch self {
        case .gasoline95:
            return LocalizedStrings.gasoline95
        case .gasoline95Premium:
            return LocalizedStrings.gasoline95Premium
        case .diesel:
            return LocalizedStrings.fuelFilterDiesel
        case .dieselPremium:
            return LocalizedStrings.dieselPremium
        case .kerosene:
            return LocalizedStrings.kerosene
        case .heatingOil:
            return LocalizedStrings.heatingOil
        case .fuelOil:
            return LocalizedStrings.fuelOil
        case .fuelOilHighSulfur:
            return LocalizedStrings.fuelOilHighSulfur
        case .autogas:
            return LocalizedStrings.autogas
        }
    }

    var fuelKey: String {
        switch self {
        case .gasoline95:
            return "gasoline95"
        case .gasoline95Premium:
            return "gasoline95_premium"
        case .diesel:
            return "diesel"
        case .dieselPremium:
            return "diesel_premium"
        case .kerosene:
            return "kerosene"
        case .heatingOil:
            return "heating_oil"
        case .fuelOil:
            return "fuel_oil"
        case .fuelOilHighSulfur:
            return "fuel_oil_high_sulfur"
        case .autogas:
            return "autogas"
        }
    }
}

struct PriceTrend: Codable {
    let fuelKey: String?
    let previousPrice: Double?
    let priceChange: Double?
    let changeDirection: ChangeDirection?
}

enum ChangeDirection: String, Codable {
    case up = "UP"
    case down = "DOWN"
    case same = "SAME"
    case noData = "NO_DATA"
}

private extension KeyedDecodingContainer {
    func decodeFlexibleStringIfPresent(forKey key: Key) throws -> String? {
        if let stringValue = try? decodeIfPresent(String.self, forKey: key) {
            return stringValue
        }

        if let intValue = try? decodeIfPresent(Int.self, forKey: key) {
            return String(intValue)
        }

        if let doubleValue = try? decodeIfPresent(Double.self, forKey: key) {
            if doubleValue.rounded() == doubleValue {
                return String(Int(doubleValue))
            }

            return String(doubleValue)
        }

        return nil
    }
}
