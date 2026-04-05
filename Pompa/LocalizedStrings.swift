import Foundation

struct LocalizedStrings {
    
    static var timeout: String {
        return localizedString(for: "timeout")
    }
    
    static var somethingWentWrong: String {
        return localizedString(for: "something_went_wrong")
    }
    
    
    static var canNotConnectToHost: String {
        return localizedString(for: "can_not_connected_to_host")
    }
    
    static var noResultFound: String {
        return localizedString(for: "no_result_found")
    }
    
    static var checkYourConnection: String {
        return localizedString(for: "check_your_connection")
    }

    static var provincesSelectTitle: String {
        return localizedString(for: "provinces_select_title")
    }

    static var retry: String {
        return localizedString(for: "retry")
    }

    static var confirm: String {
        return localizedString(for: "confirm")
    }

    static var providersSelectTitle: String {
        return localizedString(for: "providers_select_title")
    }
    
    static func localizedString(for key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
