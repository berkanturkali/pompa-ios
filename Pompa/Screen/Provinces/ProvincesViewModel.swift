import Foundation
import SwiftUI
import Combine

@MainActor
class ProvincesViewModel: ObservableObject {
    @Published private(set) var provinces: [Province] = []
    @Published var selectedProvinceCode: String?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let provinceService: ProvinceService = ProvinceService.shared
    private let pompaUserPrefs: PompaUserPrefs = .shared
    
    init() {
        selectedProvinceCode = pompaUserPrefs.userPreferences.selectedCity.0

        Task {
            await fetchProvinces()
        }
    }

    var selectedProvince: Province? {
        guard let selectedProvinceCode else { return provinces.first }
        return provinces.first(where: { $0.code == selectedProvinceCode }) ?? provinces.first
    }

    func fetchProvinces() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await provinceService.getProvinces()

            if let provinces = response.data {
                self.provinces = provinces

                if selectedProvinceCode == nil || !provinces.contains(where: { $0.code == selectedProvinceCode }) {
                    selectedProvinceCode = provinces.first?.code
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

    func selectProvince(_ province: Province) {
        selectedProvinceCode = province.code

        Task {
            await pompaUserPrefs.setSelectedCity(cityCode: province.code, cityName: province.name)
        }
    }
}
