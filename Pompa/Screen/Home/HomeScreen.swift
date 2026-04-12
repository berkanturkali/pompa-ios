import SwiftUI

struct HomeScreen: View {
    @StateObject private var viewModel = HomeScreenViewModel()
    @State private var headerOffsets: [String: CGFloat] = [:]
    @State private var showSortSheet = false
    @State private var sortSheetHeight: CGFloat = 0

    var body: some View {
        ZStack {
            PompaColors.Background.primary
                .ignoresSafeArea()

            VStack(spacing: 8) {
                header

                FuelFilters(
                    filterList: viewModel.fuelFilters,
                    selectedFilter: viewModel.selectedFuelFilter
                ) { item in
                    viewModel.setSelectedFuelType(item.type.value)
                }
                .padding(.horizontal, 8)

                Rectangle()
                    .fill(PompaColors.border)
                    .frame(height: 0.5)

                PriceDateView(date: viewModel.date)
                    .padding(.top, 8)
                    .padding(.trailing, 8)

                ScrollView {
                    if filteredProviders.isEmpty && !viewModel.isLoading {
                        Text(LocalizedStrings.noResultFound)
                            .font(PompaTypography.font(size: 13, weight: .medium))
                            .foregroundStyle(PompaColors.Text.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 48)
                    } else {
                        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                            ForEach(Array(filteredProviders.enumerated()), id: \.offset) { index, provider in
                                Section {
                                    providerContent(provider)
                                } header: {
                                    providerHeader(
                                        provider,
                                        id: providerHeaderID(for: index, provider: provider),
                                        showDivider: index != filteredProviders.indices.last
                                    )
                                }
                            }
                        }
                    }
                }
                .coordinateSpace(name: "homeScroll")
                .refreshable {
                    viewModel.refresh()
                }
            }
            .padding(8)

            if viewModel.isLoading {
                PompaLoadingView()
            }

            ZStack {
                Color.black
                    .opacity(showSortSheet ? 0.2 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                            showSortSheet = false
                        }
                    }

                VStack {
                    Spacer()

                    SortScreen(
                        sortOptions: sortOptions,
                        onSortOptionClick: { option in
                            viewModel.setSortDirection(option.direction)
                            withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                                showSortSheet = false
                            }
                        }
                    )
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    sortSheetHeight = geometry.size.height
                                }
                                .onChange(of: geometry.size.height) { _, newValue in
                                    sortSheetHeight = newValue
                                }
                        }
                    )
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
                .offset(y: showSortSheet ? 0 : sortSheetHeight + 32)
            }
            .opacity(showSortSheet ? 1 : 0)
            .allowsHitTesting(showSortSheet)
            .zIndex(10)
        }
        .onPreferenceChange(ProviderHeaderOffsetPreferenceKey.self) { headerOffsets = $0 }
        .animation(.spring(response: 0.32, dampingFraction: 0.86), value: showSortSheet)
    }
}

private extension HomeScreen {
    var filteredProviders: [FuelPriceProvider] {
        viewModel.getFilteredResults(query: viewModel.debouncedSearchQuery)
    }

    var selectedProvider: String {
        viewModel.getSelectedProvider() ?? ""
    }

    var sortOptions: [SortOption] {
        SortDataSource.getSortOptions(
            selectedDirection: viewModel.sortDirection == SortDirection.descending.rawValue ? .descending : .ascending
        )
    }

    var currentPinnedHeaderID: String? {
        Array(filteredProviders.enumerated())
            .map { (index: $0.offset, provider: $0.element) }
            .filter { (headerOffsets[providerHeaderID(for: $0.index, provider: $0.provider)] ?? .greatestFiniteMagnitude) < 0 }
            .last
            .map { providerHeaderID(for: $0.index, provider: $0.provider) }
    }

    var header: some View {
        HStack(alignment: .center, spacing: 8) {
            FuelSearchBar(value: viewModel.searchQuery) { query in
                viewModel.onSearchQueryChange(query)
            }

            SortButton {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.9)) {
                    showSortSheet = true
                }
            }
        }
        .padding(.horizontal, 8)
    }

    @ViewBuilder
    func providerHeader(_ provider: FuelPriceProvider, id: String, showDivider: Bool) -> some View {
        PriceListProviderSection(
            name: provider.provider,
            logo: provider.providerLogo,
            averagePrice: provider.averagePrice.map { String(format: "%.2f", $0) },
            isHeaderPinned: currentPinnedHeaderID == id,
            showDivider: showDivider,
            isFavorite: provider.provider == selectedProvider,
            showInfoMessage: provider.providerIsManual
        )
        .background(
            GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: ProviderHeaderOffsetPreferenceKey.self,
                        value: [id: geometry.frame(in: .named("homeScroll")).minY]
                    )
            }
        )
        .zIndex(1)
    }

    func providerHeaderID(for index: Int, provider: FuelPriceProvider) -> String {
        "\(index)-\(provider.provider)"
    }

    @ViewBuilder
    func providerContent(_ provider: FuelPriceProvider) -> some View {
        let stations = provider.data.compactMap { $0 }

        if let error = provider.error, !error.isEmpty {
            ProviderErrorView(provider: provider.provider)
                .padding(.bottom, 8)
        } else if stations.isEmpty {
            ProviderEmptyView(provider: provider.provider)
                .padding(.bottom, 8)
        } else {
            VStack(spacing: 8) {
                ForEach(stations.indices, id: \.self) { index in
                    let station = stations[index]
                    let allFuelPrices = station.prices?.mapToUiItems(
                        unit: station.unit ?? "tl/lt",
                        weightUnit: station.weightUnit ?? "tl/kg"
                    ) ?? []
                    let visibleFuelPrices = Array(allFuelPrices.prefix(3))

                    FuelItem(
                        districtName: station.districtName ?? "",
                        clickable: allFuelPrices.count > 3,
                        actualFuelPriceListCount: allFuelPrices.count,
                        fuelPrices: visibleFuelPrices,
                        fuelPriceTrends: station.priceTrends ?? [],
                        showDistrict: true,
                        onLocationButtonClick: {
                            viewModel.navigateToGoogleMapsWithLocation(
                                provider: station.brand ?? provider.provider,
                                districtName: station.districtName ?? "",
                                cityName: station.cityName ?? viewModel.cityName ?? ""
                            )
                        },
                        onItemClick: {}
                    )
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
    }
}

private struct ProviderHeaderOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [String: CGFloat] = [:]

    static func reduce(value: inout [String: CGFloat], nextValue: () -> [String: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { _, new in new })
    }
}

#Preview {
    HomeScreen()
}
