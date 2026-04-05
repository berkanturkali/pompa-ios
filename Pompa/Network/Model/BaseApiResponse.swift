//

import Foundation

struct BaseApiResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
}
