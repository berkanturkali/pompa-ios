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

    static var homeTitle: String {
        return localizedString(for: "home_title")
    }

    static var settingsTitle: String {
        return localizedString(for: "settings_title")
    }

    static var sort: String {
        return localizedString(for: "sort")
    }

    static var lowestPrice: String {
        return localizedString(for: "lowest_price")
    }

    static var highestPrice: String {
        return localizedString(for: "highest_price")
    }

    static var average: String {
        return localizedString(for: "average")
    }

    static var pricesMayVaryForThisStation: String {
        return localizedString(for: "prices_may_vary_for_this_station")
    }

    static var fuelFilterAll: String {
        return localizedString(for: "fuel_filter_all")
    }

    static var fuelFilterGasoline: String {
        return localizedString(for: "fuel_filter_gasoline")
    }

    static var fuelFilterDiesel: String {
        return localizedString(for: "fuel_filter_diesel")
    }

    static var fuelFilterLPG: String {
        return localizedString(for: "fuel_filter_lpg")
    }

    static var fuelSearchBarHint: String {
        return localizedString(for: "fuel_search_bar_hint")
    }

    static func seeAll(_ count: Int) -> String {
        return localizedString(for: "see_all", count)
    }

    static var gasoline95: String {
        return localizedString(for: "gasoline95")
    }

    static var gasoline95Premium: String {
        return localizedString(for: "gasoline95_premium")
    }

    static var dieselPremium: String {
        return localizedString(for: "diesel_premium")
    }

    static var kerosene: String {
        return localizedString(for: "kerosene")
    }

    static var heatingOil: String {
        return localizedString(for: "heating_oil")
    }

    static var fuelOil: String {
        return localizedString(for: "fuel_oil")
    }

    static var fuelOilHighSulfur: String {
        return localizedString(for: "fuel_oil_high_sulfur")
    }

    static var autogas: String {
        return localizedString(for: "autogas")
    }

    static func providerFetchError(_ provider: String) -> String {
        return localizedString(for: "something_went_wrong_while_fetching_prices_for_this_provider", provider)
    }

    static func providerEmptyResult(_ provider: String) -> String {
        return localizedString(for: "could_not_find_any_result_for_this_provider", provider)
    }
    
    static var appName: String {
        return "Pompa"
    }
    
    static func localizedString(for key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }

    static func localizedString(for key: String, _ arguments: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, locale: Locale.current, arguments: arguments)
    }
}
