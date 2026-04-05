//

import SwiftUI

struct ProvidersScreen: View {
    @StateObject private var viewModel = ProvidersViewModel()

    let showBackButton: Bool
    let title: String
    let provinceName: String
    let provinceCode: String
    let onBackButtonClick: () -> Void
    let onSelectedProvinceClick: () -> Void
    let onConfirmButtonClick: () -> Void

    var body: some View {
        ZStack {
            PompaColors.Background.primary
                .ignoresSafeArea()

            VStack(spacing: 0) {
                PompaAppTopBar(
                    showBackButton: showBackButton,
                    showSelectedProvince: false,
                    title: title,
                    provinceName: provinceName,
                    provinceCode: provinceCode,
                    onBackButtonClick: onBackButtonClick,
                    onSelectedProvinceClick: onSelectedProvinceClick
                )

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.providers) { provider in
                            ProviderItem(
                                provider: provider,
                                isSelected: provider == viewModel.selectedProvider
                            ) {
                                let selectedProvider = provider == viewModel.selectedProvider ? nil : provider
                                viewModel.selectProvider(selectedProvider)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                }
                .safeAreaInset(edge: .bottom) {
                    confirmSection
                }
            }

            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.08)
                        .ignoresSafeArea()

                    ProgressView()
                        .tint(PompaColors.Background.primary)
                        .padding(20)
                        .background(PompaColors.Background.secondary)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .alert(
            LocalizedStrings.somethingWentWrong,
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.clearError() } }
            ),
            actions: {
                Button("OK", role: .cancel) {
                    viewModel.clearError()
                }
            },
            message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
        )
        .animation(.spring(response: 0.24, dampingFraction: 0.84), value: viewModel.isLoading)
        .task {
            await viewModel.fetchProviders()
        }
    }

    private var confirmSection: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(PompaColors.border)
                .frame(height: 1)

            Button(action: {
                viewModel.saveSelectedProvider()
                onConfirmButtonClick()
            }) {
                Text(LocalizedStrings.confirm)
                    .font(PompaTypography.font(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
            }
            .buttonStyle(.plain)
            .foregroundStyle(PompaColors.Button.filledPrimaryContent)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        viewModel.confirmButtonEnabled
                        ? PompaColors.Button.filledPrimaryBackground
                        : PompaColors.Button.filledPrimaryBackground.opacity(0.5)
                    )
            )
            .opacity(viewModel.confirmButtonEnabled ? 1 : 0.5)
            .disabled(!viewModel.confirmButtonEnabled)
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 8)
            .background(PompaColors.TopBar.background)
        }
    }
}

#Preview {
    ProvidersScreen(
        showBackButton: true,
        title: LocalizedStrings.providersSelectTitle,
        provinceName: "İstanbul",
        provinceCode: "34",
        onBackButtonClick: {},
        onSelectedProvinceClick: {},
        onConfirmButtonClick: {}
    )
}
