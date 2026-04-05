import Foundation

enum PompaEndpoints {
    static let localEmulatorBaseURL = url(for: "POMPA_LOCAL_EMULATOR_BASE_URL")
    static let localBaseURL = url(for: "POMPA_LOCAL_BASE_URL")

    static let emulatorImageBaseURL = url(for: "EMULATOR_IMAGE_BASE_URL")
    static let imageBaseURL = url(for: "IMAGE_BASE_URL")

    private static func url(for key: String) -> URL {
        guard let config = Bundle.main.object(forInfoDictionaryKey: "PompaConfig") as? [String: String],
              let value = config[key],
              let url = URL(string: value) else {
            fatalError("Missing or invalid \(key) in Info.plist")
        }

        return url
    }
}
