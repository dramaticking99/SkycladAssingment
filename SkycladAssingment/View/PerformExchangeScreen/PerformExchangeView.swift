//
//  PerformExchangeView.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 15/08/25.
//

import SwiftUI

struct PerformExchangeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = PerformExchangeViewModel()

    var body: some View {
        ZStack {
            Color.black.opacity(0.96).ignoresSafeArea()

            VStack(spacing: 16) {
                // Top bar
                HStack(spacing: 24) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                    }
                    Text("Exchange")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.top, 4)

                // Cards + swap button
                ZStack {
                    VStack(spacing: 8) {
                        ExchangeCard(
                            token: vm.fromToken,
                            sideLabel: "Send",
                            amountText: vm.fromAmount,
                            balanceLeft: "Balance",
                            balanceRight: vm.fromBalance,
                            corners: [.topLeft, .topRight]
                        )
                        ExchangeCard(
                            token: vm.toToken,
                            sideLabel: "Recieve",
                            amountText: vm.toAmount,
                            balanceLeft: "Balance",
                            balanceRight: vm.toBalance,
                            corners: [.bottomLeft, .bottomRight]
                        )
                    }

                    SwapButton { vm.swapTokens() }
                        .shadow(color: .black.opacity(0.5), radius: 14, x: 0, y: 8)
                }
                .padding(.top, 6)

                // CTA
                Button(action: {}) {
                    Text("Exchange")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.brandBlue4)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                }
                .padding(.top, 4)

                // Meta rows
                VStack(spacing: 12) {
                    InfoRow(left: "Rate",          right: vm.meta.rate)
                    InfoRow(left: "Spread",        right: vm.meta.spread)
                    InfoRow(left: "Gas fee",       right: vm.meta.gasFee)
                    Divider().background(Color.white.opacity(0.08))
                    InfoRow(left: "You will recieve", right: vm.meta.willReceive, highlightRight: true)
                }
                .padding(.top, 16)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .safeAreaPadding(.bottom, 16)
            .safeAreaInset(edge: .bottom) {
                BottomAtmosphereView(height: 100)
                    .ignoresSafeArea(edges: .bottom)
                    .padding(.horizontal, 16)
                    .offset(y: 6)
                    .allowsHitTesting(false)
            }
        }
    }
}

// MARK: - Subviews

private struct ExchangeCard: View {
    let token: Token
    let sideLabel: String
    let amountText: String
    let balanceLeft: String
    let balanceRight: String
    var corners: UIRectCorner = [.allCorners]
    var radius: CGFloat = 18

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                TokenBadge(token: token)
                Spacer()
                Text(sideLabel)
                    .font(.geistMono(14, wght: 400))
                    .foregroundStyle(.textFront)
            }
            Text(amountText)
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(.white)
            HStack {
                Text(balanceLeft)
                    .font(.geistMono(14, wght: 400))
                    .foregroundStyle(.textBack)
                Spacer()
                Text(balanceRight)
                    .font(.geistMono(14, wght: 400))
                    .foregroundStyle(.textBack)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Color.panel2.mask(RoundedCorners(radius: radius, corners: corners))
        )
    }
}

private struct SwapButton: View {
    var action: () -> Void
    private let size: CGFloat = 44
    private let radius: CGFloat = 12

    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.up.arrow.down")
                .font(.system(size: 18, weight: .bold))
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(.white)
                .frame(width: size, height: size)
                .background(
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .fill(Color.panel2)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .fill(
                            RadialGradient(
                                colors: [Color.white.opacity(0.10), .clear],
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: 36
                            )
                        )
                        .blendMode(.screen)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: radius - 3, style: .continuous)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                        .padding(4)
                )
        }
        .buttonStyle(.plain)
    }
}

private struct TokenBadge: View {
    let token: Token
    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle().fill(Color.white.opacity(0.12))
                token.symbolView
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 40, height: 40)

            Text(token.title)
                .font(.geistMono(20, wght: 400))
                .foregroundStyle(.white)

            Image(systemName: "chevron.down")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.textFront)
        }
    }
}

private struct InfoRow: View {
    let left: String
    let right: String
    var highlightRight: Bool = false

    var body: some View {
        HStack {
            Text(left)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.7))
            Spacer()
            Text(right)
                .font(.system(size: highlightRight ? 15 : 13,
                              weight: highlightRight ? .semibold : .medium))
                .foregroundStyle(highlightRight ? .white : .white.opacity(0.85))
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview("PerformExchangeView") {
    PerformExchangeView()
        .preferredColorScheme(.dark)
}
