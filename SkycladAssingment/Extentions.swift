//
//  Untitled.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 14/08/25.
//

import SwiftUI

// Legacy - (Colors now added as assets)
public extension Color {
    static let tabBarTint   = Color(red: 17/255, green: 19/255, blue: 22/255)
    static let tabPillBlue  = Color(red: 15/255, green: 14/255, blue: 163/255)

    static let tabBarBorder = Color.white.opacity(0.12)
    static let tabBarSheen  = Color.white.opacity(0.06)
    static let tabPillShine = Color.white.opacity(0.22)
    static let tabOn        = Color.white
    static let tabOff       = Color.white.opacity(0.65)
    
    static let cardSurface = Color(red: 10/255, green: 10/255, blue: 12/255)
    
    static let hdrBright = Color(.sRGB, red: 40/255, green: 44/255, blue: 170/255)
    static let hdrDeep   = Color(.sRGB, red: 35/255, green: 32/255, blue: 87/255)
    
    init(hex: UInt, alpha: Double = 1) {
        self = Color(.sRGB,
                     red:   Double((hex >> 16) & 0xff) / 255,
                     green: Double((hex >>  8) & 0xff) / 255,
                     blue:  Double((hex      ) & 0xff) / 255,
                     opacity: alpha)
    }
}

import CoreText

public extension Font {
    /// Use GeistMono variable font with a SwiftUI-friendly weight mapping.
    static func geistMono(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let wght = weight._geistWghtValue
        return .geistMono(size, wght: wght)
    }

    /// Use GeistMono variable font with an explicit `wght` axis value (100…900).
    static func geistMono(_ size: CGFloat, wght: CGFloat) -> Font {
        Font(UIFont._geistMonoVariable(size: size, wght: wght))
    }
}

private extension UIFont {
    static let geistPSName = "GeistMono-VariableFont_wght" // ← if it crashes, print names (see helper below)

    /// Creates a UIFont for GeistMono variable with the given `wght` (100…900).
    static func _geistMonoVariable(size: CGFloat, wght: CGFloat) -> UIFont {
        // Clamp to sane variable range
        let w = max(100, min(900, wght))

        // Build a UIFontDescriptor with the variation axis set
        let base = UIFontDescriptor(name: geistPSName, size: size)
        let variationKey = UIFontDescriptor.AttributeName(rawValue: kCTFontVariationAttribute as String)
        let wghtTag = _fourCharCode("wght") // 'wght' axis

        let desc = base.addingAttributes([
            variationKey: [NSNumber(value: wghtTag): NSNumber(value: Double(w))]
        ])

        // Fallback to system if something goes wrong
        return UIFont(descriptor: desc, size: size)
    }
}

/// Map SwiftUI weights to the variable `wght` axis (CSS-like)
private extension Font.Weight {
    var _geistWghtValue: CGFloat {
        switch self {
        case .ultraLight: return 200
        case .thin:       return 100
        case .light:      return 300
        case .regular:    return 400
        case .medium:     return 500
        case .semibold:   return 600
        case .bold:       return 700
        case .heavy:      return 800
        case .black:      return 900
        default:          return 400
        }
    }
}

/// Turn "wght" into a four-character axis tag value
private func _fourCharCode(_ s: String) -> UInt32 {
    var result: UInt32 = 0
    for b in s.utf8 { result = (result << 8) | UInt32(b) }
    return result
}
