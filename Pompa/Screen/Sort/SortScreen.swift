import SwiftUI

enum SortDirection: Int {
    case ascending = 0
    case descending = 1
}

struct SortOption: Identifiable, Equatable {
    let id: Int
    let title: String
    let selected: Bool
    let direction: SortDirection
}

struct SortScreen: View {
    let sortOptions: [SortOption]
    let onSortOptionClick: (SortOption) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            PompaBottomSheetHandle()

            Text(LocalizedStrings.sort)
                .font(PompaTypography.font(size: 16, weight: .semibold))
                .foregroundStyle(PompaColors.Text.primary)
                .padding(.leading, 8)

            Rectangle()
                .fill(PompaColors.border)
                .frame(height: 0.5)

            let selectedOption = sortOptions.first(where: \.selected)
            ForEach(Array(sortOptions.enumerated()), id: \.element.id) { index, option in
                SortItem(sortOption: option) {
                    if selectedOption != option {
                        onSortOptionClick(option)
                    }
                }

                if index != sortOptions.indices.last {
                    Rectangle()
                        .fill(PompaColors.border)
                        .frame(height: 0.5)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
        .padding(.top, 6)
        .padding(.bottom, 12)
        .background(
            PompaColors.Background.primary,
            in: UnevenRoundedRectangle(
                topLeadingRadius: 16,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 16,
                style: .continuous
            )
        )
        .overlay(
            UnevenRoundedRectangle(
                topLeadingRadius: 16,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 16,
                style: .continuous
            )
            .stroke(PompaColors.border, lineWidth: 1)
        )
    }
}

private struct SortItem: View {
    let sortOption: SortOption
    let onItemClick: () -> Void

    var body: some View {
        Button(action: onItemClick) {
            HStack {
                Text(sortOption.title)
                    .font(PompaTypography.font(size: 12, weight: .medium))
                    .foregroundStyle(PompaColors.Text.primary)

                Spacer()

                if sortOption.selected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color(red: 0.30, green: 0.69, blue: 0.31))
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 24)
            .padding(.horizontal, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.18), value: sortOption.selected)
    }
}

#Preview {
    ZStack {
        PompaColors.Background.primary
            .ignoresSafeArea()

        VStack {
            Spacer()

            SortScreen(
                sortOptions: SortDataSource.getSortOptions(),
                onSortOptionClick: { _ in }
            )
        }
    }
}
