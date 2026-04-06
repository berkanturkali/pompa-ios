import Foundation

struct FuelService {
    static let shared = FuelService()

    private let networkManager = NetworkManager.shared
    private let fetchAllPricesByCityPath = "fuel/fetchAllFuelPricesByCity"

    private init() {}

    func fetchAllFuelPricesByCity(
        cityName: String?,
        cityCode: String?,
        provider: String?,
        sortDirection: Int,
        type: Int
    ) async throws -> Resource<[FuelPriceProvider?]> {
        let url = makeFetchAllPricesByCityURL(
            cityName: cityName,
            cityCode: cityCode,
            provider: provider,
            sortDirection: sortDirection,
            type: type
        )

        return try await networkManager.request(to: url, method: .GET)
    }

    private func makeFetchAllPricesByCityURL(
        cityName: String?,
        cityCode: String?,
        provider: String?,
        sortDirection: Int,
        type: Int
    ) -> String {
        var components = URLComponents(string: ApiConfig.url(fetchAllPricesByCityPath))
        var queryItems = [
            URLQueryItem(name: "sortDirection", value: String(sortDirection)),
            URLQueryItem(name: "fuelType", value: String(type))
        ]

        if let cityName, !cityName.isEmpty {
            queryItems.append(URLQueryItem(name: "cityName", value: cityName))
        }

        if let cityCode, !cityCode.isEmpty {
            queryItems.append(URLQueryItem(name: "cityCode", value: cityCode))
        }

        if let provider, !provider.isEmpty {
            queryItems.append(URLQueryItem(name: "provider", value: provider))
        }

        components?.queryItems = queryItems
        return components?.url?.absoluteString ?? ApiConfig.url(fetchAllPricesByCityPath)
    }
}
