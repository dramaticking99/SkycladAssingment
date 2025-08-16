//
//  LiquidGlassTabBar.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

struct LiquidGlassTabBar: View {
    @Binding var selected: MainTab

    // Public layout knobs
    var height: CGFloat = 64
    var pillInset: CGFloat = 4
    var spacing: CGFloat = 12
    var pillWidthFactor: CGFloat = 1.2

    // Private
    @Namespace private var glassNS
    private let spring = Animation.spring(response: 0.5, dampingFraction: 0.85)

    var body: some View {
        ZStack {
            // Bar background (material + exact tint)
            RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                        .fill(Color.tabBarTint)
                        .opacity(0.85)
                )
                .overlay(
                    // subtle top sheen
                    RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.tabBarSheen, .clear],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                )

            // Selection pill
            GeometryReader { geo in
                let width = geo.size.width
                let tabs = MainTab.allCases
                let count = CGFloat(tabs.count)

                let innerWidth = width - 2 * pillInset
                let cellWidth = (innerWidth - spacing * (count - 1)) / count
                let pillH = max(0, height - 2 * pillInset)
                let pillW = min(cellWidth * pillWidthFactor, innerWidth)

                let idx = CGFloat(tabs.firstIndex(of: selected) ?? 0)
                let baseCenterX = pillInset + cellWidth / 2 + idx * (cellWidth + spacing)
                let minCenterX = pillInset + pillW / 2
                let maxCenterX = width - pillInset - pillW / 2
                let centerX = min(max(baseCenterX, minCenterX), maxCenterX)

                RoundedRectangle(cornerRadius: pillH / 2, style: .continuous)
                    .fill(Color.tabPillBlue)
                    .overlay(
                        // glossy bloom toward top-left
                        RoundedRectangle(cornerRadius: pillH / 2, style: .continuous)
                            .fill(
                                RadialGradient(
                                    colors: [Color.tabPillShine, .clear],
                                    center: .topLeading,
                                    startRadius: 0,
                                    endRadius: pillH * 1.1
                                )
                            )
                            .blendMode(.screen)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: pillH / 2, style: .continuous)
                            .stroke(Color.tabBarBorder, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.35), radius: 12, y: 6)
                    .frame(width: pillW, height: pillH)
                    .position(x: centerX, y: height / 2)
                    .matchedGeometryEffect(id: "selection-pill", in: glassNS)
                    .animation(spring, value: selected)
            }

            // Buttons
            HStack(spacing: spacing) {
                ForEach(MainTab.allCases) { tab in
                    Button {
                        withAnimation(spring) { selected = tab }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 18, weight: .semibold))
                            Text(tab.title)
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(selected == tab ? Color.tabOn : Color.tabOff)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, spacing)
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: height / 2, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                .stroke(Color.tabBarBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.4), radius: 24, y: 10)
        .padding(.horizontal, 12)
    }
}

// MARK: - Preview

#Preview("LiquidGlassTabBar • 64pt", traits: .fixedLayout(width: 375, height: 812)) {
    LiquidGlassTabBar_Preview_64()
}

struct LiquidGlassTabBar_Preview_64: View {
    @State private var selected: MainTab = .analytics

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()
            LiquidGlassTabBar(selected: $selected, height: 64)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
        }
        .preferredColorScheme(.dark)
    }
}
