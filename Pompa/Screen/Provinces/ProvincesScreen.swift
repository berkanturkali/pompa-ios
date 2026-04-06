//

import SwiftUI

struct ProvincesScreen: View {
    @StateObject private var viewModel = ProvincesViewModel()
    let onProvinceSelected: (Province) -> Void

    var body: some View {
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
                                    onProvinceSelected(province)
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

#Preview {
    ProvincesScreen(onProvinceSelected: { _ in })
}
