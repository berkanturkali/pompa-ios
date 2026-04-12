import SwiftUI

struct FuelItem: View {
    let districtName: String
    let clickable: Bool
    let actualFuelPriceListCount: Int
    let fuelPrices: [FuelPriceUiModel]
    let fuelPriceTrends: [PriceTrend]
    let showDistrict: Bool
    let onLocationButtonClick: () -> Void
    let onItemClick: () -> Void
    
    init(
        districtName: String,
        clickable: Bool,
        actualFuelPriceListCount: Int,
        fuelPrices: [FuelPriceUiModel],
        fuelPriceTrends: [PriceTrend],
        showDistrict: Bool = true,
        onLocationButtonClick: @escaping () -> Void = {},
        onItemClick: @escaping () -> Void = {}
    ) {
        self.districtName = districtName
        self.clickable = clickable
        self.actualFuelPriceListCount = actualFuelPriceListCount
        self.fuelPrices = fuelPrices
        self.fuelPriceTrends = fuelPriceTrends
        self.showDistrict = showDistrict
        self.onLocationButtonClick = onLocationButtonClick
        self.onItemClick = onItemClick
    }
    
    private var trendMap: [String: PriceTrend] {
        Dictionary(uniqueKeysWithValues: fuelPriceTrends.compactMap { trend in
            guard let key = trend.fuelKey else { return nil }
            return (key, trend)
        })
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if showDistrict {
                districtHeader
            }
            
            VStack(spacing: 0) {
                ForEach(Array(fuelPrices.enumerated()), id: \.element.id) { index, priceItem in
                    FuelPriceRow(
                        title: priceItem.title.localized,
                        price: priceItem.price,
                        unit: priceItem.unit,
                        priceTrend: fuelPriceTrends.isEmpty ? nil : PriceTrendUiModel(trend: trendMap[priceItem.title.fuelKey])
                    )
                    .padding(.vertical, 6)
                    
                    if index != fuelPrices.indices.last {
                        Rectangle()
                            .fill(PompaColors.border)
                            .frame(height: 0.5)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(PompaColors.Card.primaryBackground.opacity(0.95))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(PompaColors.border, lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.08), radius: 1, y: 1)
        }
    }
    
    private var districtHeader: some View {
        HStack {
            HStack(spacing: 8) {
                Text(districtName.titleCased)
                    .font(PompaTypography.font(size: 13, weight: .black))
                    .foregroundStyle(PompaColors.Text.primary)
                    .padding(.leading, 4)
                
                Button(action: onLocationButtonClick) {
                    ZStack {
                        Circle()
                            .fill(PompaColors.Card.primaryBackground)
                        
                        Image(systemName: "location")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(PompaColors.Text.primary)
                    }
                    .frame(width: 20, height: 20)
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
            
            if clickable {
                Button(action: onItemClick) {
                    HStack(spacing: 4) {
                        Text(LocalizedStrings.seeAll(actualFuelPriceListCount))
                            .font(PompaTypography.font(size: 10, weight: .medium))
                            .foregroundStyle(PompaColors.Text.link)
                            .underline()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color(.lightGray))
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 6)
    }
}

private struct FuelPriceRow: View {
    let title: String
    let price: String
    let unit: String
    let priceTrend: PriceTrendUiModel?
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(title)
                .font(PompaTypography.font(size: 12, weight: .semibold))
                .foregroundStyle(PompaColors.Text.primary)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                VStack(alignment: .trailing, spacing: 1) {
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text(price)
                            .font(PompaTypography.font(size: 12, weight: .bold))

                        Text("₺")
                            .font(PompaTypography.font(size: 10, weight: .medium))
                    }
                    .foregroundStyle(PompaColors.Text.primary)

                    Text(unit)
                        .font(PompaTypography.font(size: 11, weight: .semibold))
                        .foregroundStyle(PompaColors.Text.primary.opacity(0.85))
                }

                if let priceTrend {
                    HStack(spacing: 4) {
                        Image(systemName: priceTrend.icon)
                            .font(.system(size: 10, weight: .bold))
                        Text(priceTrend.value)
                            .font(PompaTypography.font(size: 10, weight: .medium))
                    }
                    .foregroundStyle(priceTrend.color)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 6)
    }
}

#Preview {
    ZStack {
        PompaColors.Background.primary
            .ignoresSafeArea()
        
        FuelItem(
            districtName: "Kadikoy",
            clickable: true,
            actualFuelPriceListCount: 5,
            fuelPrices: [
                FuelPriceUiModel(title: .gasoline95, price: "45.19", unit: "tl/lt"),
                FuelPriceUiModel(title: .diesel, price: "46.07", unit: "tl/lt"),
                FuelPriceUiModel(title: .autogas, price: "25.44", unit: "tl/lt")
            ],
            fuelPriceTrends: [
                PriceTrend(fuelKey: "gasoline95", previousPrice: 44.99, priceChange: 0.20, changeDirection: .up),
                PriceTrend(fuelKey: "diesel", previousPrice: 46.25, priceChange: -0.18, changeDirection: .down)
            ]
        )
        .padding(16)
    }
}
