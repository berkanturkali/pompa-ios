import Combine
import Foundation
import UIKit

@MainActor
final class HomeScreenViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var results: [FuelPriceProvider] = []
    @Published private(set) var selectedFuelFilter: FuelFilterItem?
    @Published private(set) var date: String
    @Published var searchQuery = ""
    @Published private(set) var debouncedSearchQuery = ""
    
    var sortDirection = 0
    var fuelType = 0
    var cityCode: String?
    var cityName: String?
    var favProviderName: String?
    let fuelFilters = FuelFilterDataSource.getFilters()
    
    private let fuelService: FuelService = .shared
    private let pompaFilterPrefs: PompaFilterPrefs = .shared
    private let pompaUserPrefs: PompaUserPrefs = .shared
    private var cancellables = Set<AnyCancellable>()
    private var fetchTask: Task<Void, Never>?
    
    init() {
        self.date = Self.getDate()
        
        bindSearchQuery()
        bindPreferences()
    }
    
    deinit {
        fetchTask?.cancel()
    }
    
    func fetchPrices(
        cityCode: String?,
        cityName: String?,
        provider: String?,
        sortDirection: Int,
        fuelType: Int
    ) {
        fetchTask?.cancel()
        
        isLoading = true
        errorMessage = nil
        results = []
        date = Self.getDate()
        
        fetchTask = Task { [weak self] in
            guard let self else { return }
            
            do {
                let response = try await fuelService.fetchAllFuelPricesByCity(
                    cityName: cityName,
                    cityCode: cityCode,
                    provider: provider,
                    sortDirection: sortDirection,
                    type: fuelType
                )
                
                guard !Task.isCancelled else { return }
                
                if let data = response.data {
                    results = data.compactMap { $0 }
                } else if let error = response.error {
                    errorMessage = NetworkManager.shared.handleNetworkError(error)
                } else {
                    errorMessage = LocalizedStrings.somethingWentWrong
                }
            } catch {
                guard !Task.isCancelled else { return }
                
                if let networkError = error as? NetworkError {
                    errorMessage = NetworkManager.shared.handleNetworkError(networkError)
                } else {
                    errorMessage = error.localizedDescription
                }
            }
            
            isLoading = false
        }
    }
    
    func setSelectedFuelType(_ type: Int) {
        Task {
            await pompaFilterPrefs.setSelectedFuelType(type)
        }
    }
    
    func getSelectedProvider() -> String? {
        pompaUserPrefs.userPreferences.favoriteProvider.1
    }
    
    func navigateToGoogleMapsWithLocation(
        provider: String,
        districtName: String,
        cityName: String,
        zoom: Int = 18
    ) {
        let query = "\(provider) \(districtName) \(cityName.lowercased())"
        var components = URLComponents(string: "https://www.google.com/maps/search/")
        
        components?.queryItems = [
            URLQueryItem(name: "api", value: "1"),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "zoom", value: String(zoom))
        ]
        
        guard let url = components?.url else { return }
        UIApplication.shared.open(url)
    }
    
    func onSearchQueryChange(_ query: String) {
        searchQuery = query
    }
    
    func getFilteredResults(query: String) -> [FuelPriceProvider] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return results }
        
        let lowercasedQuery = trimmed.lowercased()
        
        return results
            .map { provider in
                let filteredStations = provider.data.filter { station in
                    let district = station?.districtName?.lowercased() ?? ""
                    let name = station?.brand?.lowercased() ?? ""
                    return district.contains(lowercasedQuery) || name.contains(lowercasedQuery)
                }
                
                return provider.copy(data: filteredStations)
            }
            .filter { !$0.data.isEmpty }
    }
    
    static func getDate(
        pattern: String = "dd/MM/yyyy",
        date: Date = Date()
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        formatter.locale = .current
        return formatter.string(from: date)
    }
    
    private func bindSearchQuery() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .assign(to: &$debouncedSearchQuery)
    }
    
    private func bindPreferences() {
        pompaFilterPrefs.$filterPreferences
            .combineLatest(pompaUserPrefs.$userPreferences)
            .sink { [weak self] filterPrefs, userPrefs in
                guard let self else { return }
                
                sortDirection = filterPrefs.sortDirection
                fuelType = filterPrefs.fuelType
                selectedFuelFilter = fuelFilters.first { $0.type.value == self.fuelType }
                
                let (cityCode, cityName) = userPrefs.selectedCity
                let (_, favoriteName) = userPrefs.favoriteProvider
                
                self.cityName = cityName
                self.cityCode = cityCode
                self.favProviderName = favoriteName
                
                fetchPrices(
                    cityCode: cityCode,
                    cityName: cityName,
                    provider: favoriteName,
                    sortDirection: sortDirection,
                    fuelType: fuelType
                )
            }
            .store(in: &cancellables)
    }
}
