import Foundation

struct ProviderService {
    static let shared = ProviderService()

    private let networkManager = NetworkManager.shared
    private let providersURL = "brand/all"

    private init() {}

    func getProviders() async throws -> Resource<[Provider]> {
        let url = ApiConfig.url(providersURL)
        return try await networkManager.request(to: url, method: .GET)
    }
}
