//
//  AnalyticsView.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

struct AnalyticsView: View {
    @StateObject private var vm = AnalyticsViewModel()

    private let headerHeight: CGFloat = 240
    private let pagePadding: CGFloat = 16
    private let sectionSpacing: CGFloat = 16

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: sectionSpacing) {
                AnalyticsHeaderView(
                    height: headerHeight,
                    showINR: $vm.showINR,
                    formattedValue: vm.formattedPortfolioValue(showINR: vm.showINR)
                )
                .padding(.horizontal, 8)

                TimeRangePicker(selected: $vm.timeRange)
                    .padding(.horizontal, pagePadding)

                PriceChartView(points: vm.series, selected: $vm.selectedPoint)
                    .id(vm.timeRange)
                    .frame(height: 220)
                    .padding(.horizontal, pagePadding)

                CoinRowView(
                    coins: vm.coins,
                    formatINR: vm.formatINR(_:),
                    pctString: vm.pctString(_:)
                )
                .padding(.horizontal, pagePadding)
                .padding(.bottom, 12)

                // Shared Componenet
                RecentTransactionsSection(rows: vm.txns)
                    .padding(.horizontal, pagePadding)
                    .padding(.bottom, 24)
            }
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
    }
}

//MARK: - Subviews

private struct AnalyticsHeaderView: View {
    let height: CGFloat
    @Binding var showINR: Bool
    let formattedValue: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            Image("HeaderBackground")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: height)
                .clipped()
                .rotationEffect(.degrees(180))
                .mask(RoundedCorners(radius: 24, corners: [.bottomLeft, .bottomRight]))
                .padding(.horizontal, 4)
            
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Portfolio Value >")
                        .font(.geistMono(14, wght: 400))
                        .foregroundStyle(.white.opacity(0.92))
                    Spacer()
                    CurrencyChip(showINR: $showINR, width: 100, height: 38)
                }

                Text(formattedValue)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.bottom, 10)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(height: height)
    }
}

//MARK: - Preview

#Preview {
    AnalyticsView()
}

