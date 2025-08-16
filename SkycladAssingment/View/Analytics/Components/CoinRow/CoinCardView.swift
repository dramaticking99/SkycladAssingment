//
//  CoinCardView.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 14/08/25.
//

import SwiftUI

struct CoinCardView: View {
    let coin: CoinSummary
    let formatINR: (Double) -> String
    let pctString: (Double) -> String

    private let cardSize = CGSize(width: 204, height: 118)

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Card background
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )

            // Content
            VStack(alignment: .leading, spacing: 24) {
                // Title row
                HStack(spacing: 24) {
                    // Icon badge (top/left = 16 via ZStack padding below)
                    ZStack {
                        Circle().fill(Color.orange)
                        Image(systemName: coin.icon) // e.g. "bitcoinsign.circle.fill"
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 42, height: 42)

                    Text("\(coin.name) (\(coin.symbol))")
                        .font(.geistMono(14, wght: 400))
                        .foregroundStyle(Color.textFront)
                        .lineLimit(1)
                }
                
                // Value + gain on the same row
                // Bottom row (exactly 16 from bottom)
                HStack(alignment: .firstTextBaseline) {
                    Text(formatINR(coin.price))
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(Color.textFront)
                        .lineLimit(1)
                    
                    Spacer(minLength: 8)
                    
                    Text(pctString(coin.changePct))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(coin.changePct >= 0 ? .green : .red)
                        .lineLimit(1)
                }
            }
            .padding(.init(top: 16, leading: 16, bottom: 14, trailing: 14))
        }
        .frame(width: cardSize.width, height: cardSize.height, alignment: .topLeading)
    }
}
