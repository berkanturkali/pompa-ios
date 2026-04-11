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
