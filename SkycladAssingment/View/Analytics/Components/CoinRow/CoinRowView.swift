//
//  CoinRow.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

import SwiftUI

struct CoinRowView: View {
    let coins: [CoinSummary]
    let formatINR: (Double) -> String
    let pctString: (Double) -> String
    var cardWidth: CGFloat = 200
    var cardHeight: CGFloat = 118

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(coins) { c in
                    CoinCardView(coin: c, formatINR: formatINR, pctString: pctString)
                        .frame(alignment: .leading)
                }
            }
            .padding(.horizontal, 2)
        }
    }
}
