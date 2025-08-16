//
//  ExchangeView.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 15/08/25.
//

import SwiftUI

struct ExchangeView: View {
    @StateObject private var vm: ExchangeViewModel

    init(vm: ExchangeViewModel = ExchangeViewModel()) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 36) {

                // Gradient balance card (values come from VM)
                BalanceCard(
                    currencyTag: vm.currencyTag,
                    amountText: vm.formattedBalance(),
                    subAmountText: vm.formattedDeltaAmount(),
                    changeText: vm.pctString(vm.changePct)
                )

                // Quick actions wired to VM
                QuickActionsRow(
                    onReceive: { vm.receiveTapped() },
                    onCenter:  { vm.newTradeTapped() },
                    onSend:    { vm.sendTapped() }
                )

                // Existing list component driven by VM
                RecentTransactionsSection(rows: vm.txns)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .padding(.top, 8)
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

// MARK: - Subviews

private struct BalanceCard: View {
    let currencyTag: String
    let amountText: String
    let subAmountText: String
    let changeText: String

    private let h: CGFloat = 180
    private let r: CGFloat = 24

    var body: some View {
        ZStack(alignment: .center) {

            RoundedRectangle(cornerRadius: r, style: .continuous)
                .fill(.brandBlue3)
                .frame(width : 340, height: h)
                .offset(y: 22)
                .allowsHitTesting(false)

            RoundedRectangle(cornerRadius: r, style: .continuous)
                .fill(.brandPurple2)
                .frame(width : 360, height: h)
                .offset(y: 11)
                .allowsHitTesting(false)

            Image("CardBackground")
                .resizable()
                .scaledToFill()
                .frame(height: h)
                .rotationEffect(.degrees(90))
                .clipShape(RoundedRectangle(cornerRadius: r, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: r, style: .continuous)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                )
                .contentShape(RoundedRectangle(cornerRadius: r, style: .continuous))

            // currency chip
                .overlay(
                    Text(currencyTag)
                        .font(.geistMono(14, wght: 500))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(.brandBlue.opacity(0.5)))
                        .padding(.top, 24), alignment: .top
                )
            
            // big amount
                .overlay(
                    Text(amountText)
                        .font(.system(size: 40, weight: .semibold).monospacedDigit())
                        .foregroundStyle(.white),
                    alignment: .center
                )
            
            // subline
                .overlay(
                    HStack(spacing: 10) {
                        Text(subAmountText)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.9))
                        Text(changeText)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.green)
                    }
                        .padding(.bottom, 36),
                    alignment: .bottom
                )
        }
        .frame(height: h)
    }
}


private struct QuickActionsRow: View {
    var onReceive: () -> Void
    var onCenter:  () -> Void
    var onSend:    () -> Void
    
    var body: some View {
        HStack(spacing: 24) {
            QuickActionButton(systemName: "arrow.up") { onReceive() }
            QuickActionButton(systemName: "plus")     { onCenter() }
            QuickActionButton(systemName: "arrow.down"){ onSend() }
        }
    }
}

private struct QuickActionButton: View {
    let systemName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.12), .white.opacity(0.06)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle().stroke(.white.opacity(0.10), lineWidth: 1)
                    )
                Image(systemName: systemName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 52, height: 52)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

struct ExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExchangeView() // uses default VM + demo data
                .preferredColorScheme(.dark)
                .previewDisplayName("Exchange")

            // Inject a custom VM if you want to test different states:
            ExchangeView(vm: {
                let vm = ExchangeViewModel(balanceINR: 250_000, changeINR: -2_150, changePct: -0.9)
                vm.txns = []
                return vm
            }())
            .preferredColorScheme(.dark)
            .previewDisplayName("Empty Txns / Negative Change")
        }
    }
}
