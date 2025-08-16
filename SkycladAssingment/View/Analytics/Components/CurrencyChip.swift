//
//  CurrencyChip.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

struct CurrencyChip: View {
    // External state (kept same name to avoid breaking callers)
    @Binding var showINR: Bool

    // Public knobs
    var width: CGFloat? = nil
    var minWidth: CGFloat = 120
    var height: CGFloat = 32
    var thumbWidthFactor: CGFloat = 1.30
    var iconSeparation: CGFloat = 8
    var innerClearance: CGFloat = 0

    // Styling
    private let barTint = Color(red: 17/255, green: 19/255, blue: 22/255)

    // Constants
    private enum Layout {
        static let inset: CGFloat = 3
        static let baseBorder: CGFloat = 1
        static let baseBorderOpacity: CGFloat = 0.12
        static let thumbShadowRadius: CGFloat = 8
        static let thumbShadowY: CGFloat = 4
        static let iconFontSize: CGFloat = 15
        static let iconHPad: CGFloat = 14
    }

    private let spring = Animation.spring(response: 0.35, dampingFraction: 0.9)

    var body: some View {
        ZStack {
            base
            thumb
            icons
        }
        .frame(height: height)
        .frame(width: width)
        .frame(minWidth: minWidth)
        .overlay(hitTargets)
        .contentShape(Capsule())
        .animation(spring, value: showINR)
        .sensoryFeedback(.impact(weight: .medium), trigger: showINR)
        // A11y
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Currency")
        .accessibilityValue(showINR ? "INR" : "Bitcoin")
        .accessibilityAdjustableAction { dir in
            switch dir {
            case .increment: showINR = false   // move right (BTC)
            case .decrement: showINR = true    // move left (INR)
            default: break
            }
        }
    }

    // MARK: - Layers

    private var base: some View {
        Capsule(style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay(Capsule(style: .continuous).fill(barTint).opacity(0.85))
            .overlay(Capsule(style: .continuous).stroke(.white.opacity(Layout.baseBorderOpacity),
                                                        lineWidth: Layout.baseBorder))
    }

    private var thumb: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = max(height, proxy.size.height)
            let inset = Layout.inset

            // Track geometry
            let available = w - inset * 2
            let halfTrack = available / 2

            // Width capped so there’s always some gap around the center split
            let capByClearance = max(halfTrack - innerClearance, 0)
            let pillW = min(halfTrack * thumbWidthFactor, capByClearance, available - 2)
            let pillH = h - inset * 2
            let radius = pillH / 2

            // Ideal centers of left/right halves
            let leftCenterRaw  = inset + halfTrack / 2
            let rightCenterRaw = w - inset - halfTrack / 2

            // Offset a bit so icons look centered within the pill
            let leftDesired  = leftCenterRaw  - iconSeparation
            let rightDesired = rightCenterRaw + iconSeparation

            // Clamp within track
            let minCenter = inset + pillW / 2
            let maxCenter = w - inset - pillW / 2
            let centerX = showINR
            ? max(leftDesired,  minCenter)
            : min(rightDesired, maxCenter)

            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(Color.black.opacity(0.70))
                .overlay(
                    RadialGradient(
                        colors: [Color.white.opacity(0.18), .clear],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: pillH * 0.9
                    )
                    .mask(RoundedRectangle(cornerRadius: radius, style: .continuous))
                )
                .frame(width: pillW, height: pillH)
                .position(x: centerX, y: h / 2)
                .shadow(color: .black.opacity(0.25),
                        radius: Layout.thumbShadowRadius,
                        y: Layout.thumbShadowY)
        }
    }

    private var icons: some View {
        HStack(spacing: 0) {
            Image(systemName: "banknote")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .offset(x: -iconSeparation)
                .foregroundStyle(showINR ? .white : .white.opacity(0.55))

            Image(systemName: "bitcoinsign")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .offset(x: iconSeparation)
                .foregroundStyle(showINR ? .white.opacity(0.55) : .white)
        }
        .font(.system(size: Layout.iconFontSize, weight: .semibold))
        .padding(.horizontal, Layout.iconHPad)
    }

    private var hitTargets: some View {
        HStack(spacing: 0) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { withAnimation(spring) { showINR = true } }

            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { withAnimation(spring) { showINR = false } }
        }
    }
}

#Preview("CurrencyChip – fixed 100") {
    ZStack {
        Color.black.ignoresSafeArea()
        CurrencyChip(showINR: .constant(true),
                     width: 100,
                     height: 38,
                     thumbWidthFactor: 1.22)
    }
    .preferredColorScheme(.dark)
}
