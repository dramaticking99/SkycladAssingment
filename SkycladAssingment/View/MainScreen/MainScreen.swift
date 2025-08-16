//
//  MainScreen.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

struct MainScreen: View {
    @StateObject private var vm = MainViewModel()

    private enum Layout {
        static let buttonSize: CGFloat = 64
        static let topIconSize: CGFloat = 44
        static let hPad: CGFloat = 16
    }
    private let spring = Animation.spring(response: 0.5, dampingFraction: 0.85)

    var body: some View {
        ZStack {
            Group {
                switch vm.selectedTab {
                case .analytics: AnalyticsView()
                case .exchange:  ExchangeView()
                case .record:    RecordView()
                case .wallet:    WalletView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
        }

        .safeAreaInset(edge: .top) {
            TopControls(size: Layout.topIconSize)
                .padding(.horizontal, Layout.hPad)
        }
        
        .safeAreaInset(edge: .bottom) {
            ZStack {
                BottomAtmosphereView(height: Layout.buttonSize)
                    .ignoresSafeArea(edges: .bottom)
                    .padding(.horizontal, -Layout.hPad)
                    .offset(y: 6)
                    .allowsHitTesting(false)

                HStack(spacing: 4) {
                    LiquidGlassTabBar(selected: $vm.selectedTab, height: Layout.buttonSize)
                        .frame(maxWidth: .infinity)

                    if vm.showPlusButton {
                        FloatingPlusButton(size: Layout.buttonSize) {
                            vm.didTapPlus()
                        }
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, Layout.hPad)
                .padding(.bottom, 8)
            }
            .animation(spring, value: vm.showPlusButton)
        }

        .onChange(of: vm.selectedTab, initial: true) { _, newTab in
            vm.setPlusVisible(newTab != .exchange)
        }
        
        .fullScreenCover(isPresented: $vm.isPresentingPerformExchange) {
            PerformExchangeView()
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Subviews

private struct TopControls: View {
    let size: CGFloat
    var body: some View {
        HStack {
            GlassIconButton(systemName: "line.3.horizontal", size: size) { }
            Spacer()
            GlassIconButton(systemName: "bell", size: size) { }
        }
    }
}

#Preview {
    MainScreen()
}
