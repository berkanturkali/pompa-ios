import Foundation

extension String {
    var titleCased: String {
        lowercased().capitalized(with: .current)
    }
}
