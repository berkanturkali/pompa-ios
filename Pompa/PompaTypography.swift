import SwiftUI
import UIKit
import CoreText

enum PompaTypography {
    static func font(
        size: CGFloat,
        weight: Font.Weight = .regular,
        italic: Bool = false
    ) -> Font {
        Font(uiFont(size: size, weight: weight, italic: italic))
    }

    static func uiFont(
        size: CGFloat,
        weight: Font.Weight = .regular,
        italic: Bool = false
    ) -> UIFont {
        if let fontName = fontNames[asset(for: weight, italic: italic)],
           let customFont = UIFont(name: fontName, size: size) {
            return customFont
        }

        return .systemFont(ofSize: size, weight: uiKitWeight(for: weight))
    }

    private static func asset(for weight: Font.Weight, italic: Bool) -> FontAsset {
        switch weight {
        case .black:
            return italic ? .blackItalic : .black
        case .bold:
            return italic ? .boldItalic : .bold
        case .heavy:
            return italic ? .extraBoldItalic : .extraBold
        case .semibold:
            return italic ? .semiBoldItalic : .semiBold
        case .medium:
            return italic ? .mediumItalic : .medium
        case .light:
            return italic ? .lightItalic : .light
        case .thin, .ultraLight:
            return italic ? .thinItalic : .thin
        default:
            return italic ? .italic : .regular
        }
    }

    private static func uiKitWeight(for weight: Font.Weight) -> UIFont.Weight {
        switch weight {
        case .black:
            return .black
        case .bold:
            return .bold
        case .heavy:
            return .heavy
        case .semibold:
            return .semibold
        case .medium:
            return .medium
        case .light:
            return .light
        case .thin, .ultraLight:
            return .thin
        default:
            return .regular
        }
    }

    private static let fontNames: [FontAsset: String] = Dictionary(
        uniqueKeysWithValues: FontAsset.allCases.compactMap { asset in
            let url = Bundle.main.url(forResource: asset.rawValue, withExtension: "ttf")
                ?? Bundle.main.url(forResource: asset.rawValue, withExtension: "ttf", subdirectory: "Fonts")

            guard let url,
                  let provider = CGDataProvider(url: url as CFURL),
                  let cgFont = CGFont(provider),
                  let postScriptName = cgFont.postScriptName as String? else {
                return nil
            }

            return (asset, postScriptName)
        }
    )
}

private enum FontAsset: String, CaseIterable {
    case black = "montserrat_black"
    case blackItalic = "montserrat_black_italic"
    case bold = "montserrat_bold"
    case boldItalic = "montserrat_bold_italic"
    case extraBold = "montserrat_extrabold"
    case extraBoldItalic = "montserrat_extrabold_italic"
    case italic = "montserrat_italic"
    case light = "montserrat_light"
    case lightItalic = "montserrat_light_italic"
    case medium = "montserrat_medium"
    case mediumItalic = "montserrat_medium_italic"
    case regular = "montserrat_regular"
    case semiBold = "montserrat_semibold"
    case semiBoldItalic = "montserrat_semibold_italic"
    case thin = "montserrat_thin"
    case thinItalic = "montserrat_thin_italic"
}
