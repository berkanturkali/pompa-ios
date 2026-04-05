import Foundation
import SwiftUI
import Combine

@MainActor
final class ProvidersViewModel: ObservableObject {
    @Published private(set) var providers: [Provider] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var selectedProviderID: Int?

    private let providerService: ProviderService = ProviderService.shared

    var selectedProvider: Provider? {
        guard let selectedProviderID else { return nil }
        return providers.first(where: { $0.id == selectedProviderID })
    }

    var confirmButtonEnabled: Bool {
        selectedProvider != nil
    }

    func fetchProviders() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await providerService.getProviders()

            if let providers = response.data {
                self.providers = providers

                if let selectedProviderID,
                   !providers.contains(where: { $0.id == selectedProviderID }) {
                    self.selectedProviderID = nil
                }
            } else if let error = response.error {
                errorMessage = NetworkManager.shared.handleNetworkError(error)
            } else {
                errorMessage = LocalizedStrings.somethingWentWrong
            }
        } catch {
            if let networkError = error as? NetworkError {
                errorMessage = NetworkManager.shared.handleNetworkError(networkError)
            } else {
                errorMessage = error.localizedDescription
            }
        }

        isLoading = false
    }

    func selectProvider(_ provider: Provider?) {
        selectedProviderID = provider?.id
    }

    func clearError() {
        errorMessage = nil
    }
}
