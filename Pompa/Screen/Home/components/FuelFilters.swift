import SwiftUI

struct FuelFilters: View {
    let filterList: [FuelFilterItem]
    let selectedFilter: FuelFilterItem?
    let onFilterSelected: (FuelFilterItem) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                let itemCount = max(filterList.count, 1)
                let totalSpacing = CGFloat(max(filterList.count - 1, 0)) * 8
                let itemWidth = max((geometry.size.width - totalSpacing) / CGFloat(itemCount), 0)
                
                HStack(alignment: .center, spacing: 12) {
                    ForEach(filterList) { filterItem in
                        FuelFilterChip(
                            selected: selectedFilter == filterItem,
                            filter: filterItem.value,
                            icon: filterItem.icon
                        ) {
                            if selectedFilter != filterItem {
                                onFilterSelected(filterItem)
                            }
                        }
                        .frame(width: itemWidth)
                    }
                }
                .frame(width: geometry.size.width, alignment: .center)
                .padding(.vertical, 8)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

private struct FuelFilterChip: View {
    let selected: Bool
    let filter: String
    let icon: String
    let onItemClick: () -> Void
    
    var body: some View {
        Button(action: onItemClick) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                
                Text(filter)
                    .font(PompaTypography.font(size: 10, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(selected ? PompaColors.Chip.selectedText : PompaColors.Chip.unselectedText)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(selected ? PompaColors.Chip.selectedBackground : PompaColors.Chip.unselectedBackground)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        selected ? PompaColors.Chip.selectedBorder : PompaColors.Chip.unselectedBorder,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        PompaColors.Background.primary
            .ignoresSafeArea()
        
        FuelFilters(
            filterList: FuelFilterDataSource.getFilters(),
            selectedFilter: FuelFilterDataSource.getFilters()[0]
        ) { _ in }
            .padding(16)
    }
}
