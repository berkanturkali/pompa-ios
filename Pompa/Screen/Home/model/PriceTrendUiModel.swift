//

import Foundation
import SwiftUI

struct PriceTrendUiModel {
    let value: String
    let icon: String
    let color: Color
    
    init?(trend: PriceTrend?) {
        guard let trend, let direction = trend.changeDirection, let priceChange = trend.priceChange else {
            return nil
        }
        
        switch direction {
        case .up:
            value = String(format: "+%.2f", priceChange)
            icon = "arrow.up"
            color = .red
        case .down:
            value = String(format: "%.2f", priceChange)
            icon = "arrow.down"
            color = .green
        case .same:
            return nil
        case .noData:
            return nil
        }
    }
}
