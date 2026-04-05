//

import Foundation

struct ApiConfig {
    private static let config: [String: String] = {
        guard let config = Bundle.main.object(forInfoDictionaryKey: "PompaConfig") as? [String: String] else {
            fatalError("Missing PompaConfig in Info.plist")
        }

        return config
    }()

    static let baseURL: URL = {
        #if targetEnvironment(simulator)
        return value(for: "POMPA_LOCAL_EMULATOR_BASE_URL")
        #else
        return value(for: "POMPA_LOCAL_BASE_URL")
        #endif
    }()

    static let imageBaseURL: URL = {
        return value(for: "IMAGE_BASE_URL")       
    }()

    static func url(_ path: String) -> String {
        let normalized = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return baseURL.appendingPathComponent(normalized).absoluteString
    }

    private static func value(for key: String) -> URL {
        guard let rawValue = config[key], let url = URL(string: rawValue) else {
            fatalError("Missing or invalid \(key) in PompaConfig")
        }

        return url
    }
}
