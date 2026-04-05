import Foundation

struct Provider: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let logo: String?
    let isManual: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logo = "logo_url"
        case isManual = "is_manual"
    }
}
