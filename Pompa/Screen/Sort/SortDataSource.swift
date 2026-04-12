//

import Foundation

enum SortDataSource {
    static func getSortOptions(selectedDirection: SortDirection = .ascending) -> [SortOption] {
        [
            SortOption(
                id: 0,
                title: LocalizedStrings.lowestPrice,
                selected: selectedDirection == .ascending,
                direction: .ascending
            ),
            SortOption(
                id: 1,
                title: LocalizedStrings.highestPrice,
                selected: selectedDirection == .descending,
                direction: .descending
            )
        ]
    }
}
