//

import SwiftUI

struct ProvincesScreen: View {
    @StateObject private var viewModel = ProvincesViewModel()
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack(alignment: .top) {
                PompaColors.Background.primary
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    PompaAppTopBar(
                        showBackButton: false,
                        showSelectedProvince: false,
                        title: LocalizedStrings.provincesSelectTitle,
                        provinceName: viewModel.selectedProvince?.name ?? "",
                        provinceCode: viewModel.selectedProvince?.code ?? "",
                        onBackButtonClick: {},
                        onSelectedProvinceClick: {}
                    )

                    Group {
                        if viewModel.isLoading && viewModel.provinces.isEmpty {
                            ProgressView()
                                .tint(PompaColors.Text.primary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        } else if let errorMessage = viewModel.errorMessage, viewModel.provinces.isEmpty {
                            VStack(spacing: 12) {
                                Text(errorMessage)
                                    .font(PompaTypography.font(size: 15, weight: .medium))
                                    .foregroundStyle(PompaColors.Text.primary)
                                    .multilineTextAlignment(.center)

                                Button(LocalizedStrings.retry) {
                                    Task {
                                        await viewModel.fetchProvinces()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(PompaColors.Button.filledPrimaryBackground)
                            }
                            .padding(.horizontal, 24)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(viewModel.provinces, id: \.id) { province in
                                        ProvinceItem(
                                            province: province
                                        ) {
                                            withAnimation(.spring(response: 0.24, dampingFraction: 0.82)) {
                                                viewModel.selectProvince(province)
                                                navigationPath.append(province)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.top, 16)
                                .padding(.bottom, 32)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: Province.self) { province in
                ProvidersScreen(
                    showBackButton: true,
                    title: LocalizedStrings.providersSelectTitle,
                    provinceName: province.name,
                    provinceCode: province.code,
                    onBackButtonClick: {
                        if !navigationPath.isEmpty {
                            navigationPath.removeLast()
                        }
                    },
                    onSelectedProvinceClick: {
                        navigationPath.removeLast(navigationPath.count)
                    },
                    onConfirmButtonClick: {}
                )
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ProvincesScreen()
}
