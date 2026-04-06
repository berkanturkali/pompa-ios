import SwiftUI

struct PriceListProviderSection: View {
    let name: String
    let logo: String?
    let averagePrice: String?
    let isHeaderPinned: Bool
    let showDivider: Bool
    let isFavorite: Bool
    let showInfoMessage: Bool

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    HStack(spacing: 8) {
                        ProviderLogoView(logoPath: logo)
                            .frame(width: 42, height: 42)

                        Text(name.titleCased)
                            .font(PompaTypography.font(size: 14, weight: .bold))
                            .foregroundStyle(PompaColors.Text.primary)

                        if isFavorite {
                            Image(systemName: "star.fill")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color(red: 1.0, green: 0.84, blue: 0.0))
                        }
                    }

                    Spacer(minLength: 12)

                    if let averagePrice {
                        averagePriceBadge(averagePrice)
                    }
                }
                .padding(.horizontal, isHeaderPinned ? 10 : 8)
                .padding(.vertical, isHeaderPinned ? 8 : 0)

                if showInfoMessage {
                    Text(LocalizedStrings.pricesMayVaryForThisStation)
                        .font(PompaTypography.font(size: 9, weight: .light, italic: true))
                        .foregroundStyle(PompaColors.Text.primary.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.top, isHeaderPinned ? 0 : 4)
                        .padding(.trailing, 12)
                        .padding(.bottom, isHeaderPinned ? 8 : 0)
                }
            }
            .padding(.horizontal, isHeaderPinned ? 0 : 8)
            .padding(.vertical, isHeaderPinned ? 0 : 8)
            .background(PompaColors.Background.primary)

            if isHeaderPinned && showDivider {
                Rectangle()
                    .fill(PompaColors.border)
                    .frame(height: 1)
            }
        }
        .frame(maxWidth: .infinity)
        .background(PompaColors.Background.primary)
        .animation(.spring(response: 0.28, dampingFraction: 0.86), value: isHeaderPinned)
    }

    private func averagePriceBadge(_ averagePrice: String) -> some View {
        HStack(spacing: 4) {
            Text(LocalizedStrings.average)
                .font(PompaTypography.font(size: 11, weight: .medium))
                .foregroundStyle(PompaColors.Text.primary.opacity(0.7))

            HStack(alignment: .firstTextBaseline, spacing: 1) {
                Text(averagePrice)
                    .font(PompaTypography.font(size: 13, weight: .bold))

                Text("₺")
                    .font(PompaTypography.font(size: 11, weight: .regular))
            }
            .foregroundStyle(PompaColors.Text.primary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(PompaColors.Background.primary)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(PompaColors.border.opacity(0.8), lineWidth: 0.5)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        PriceListProviderSection(
            name: "Opet",
            logo: nil,
            averagePrice: "42.12",
            isHeaderPinned: false,
            showDivider: true,
            isFavorite: true,
            showInfoMessage: true
        )

        PriceListProviderSection(
            name: "Shell",
            logo: nil,
            averagePrice: "43.24",
            isHeaderPinned: true,
            showDivider: true,
            isFavorite: false,
            showInfoMessage: true
        )
    }
    .background(PompaColors.Background.primary)
}
