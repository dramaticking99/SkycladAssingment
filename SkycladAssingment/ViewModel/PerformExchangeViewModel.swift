//
//  PerformExchangeViewModel.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 16/08/25.
//

import SwiftUI

final class PerformExchangeViewModel: ObservableObject {
    @Published var fromToken: Token
    @Published var toToken: Token
    @Published var fromAmount: String

    // Display data (mocked for now)
    @Published var fromBalance: String
    @Published var toAmount: String
    @Published var toBalance: String

    struct Meta {
        var rate: String
        var spread: String
        var gasFee: String
        var willReceive: String
    }
    @Published var meta: Meta

    init(
        fromToken: Token = .eth,
        toToken: Token = .inr,
        fromAmount: String = "2.640",
        fromBalance: String = "10.254",
        toAmount: String = "₹ 4,65,006.44",
        toBalance: String = "4,35,804",
        meta: Meta = .init(
            rate: "1 ETH = ₹ 1,76,138.80",
            spread: "0.2%",
            gasFee: "₹ 422.73",
            willReceive: "₹ 1,75,716.07"
        )
    ) {
        self.fromToken = fromToken
        self.toToken = toToken
        self.fromAmount = fromAmount
        self.fromBalance = fromBalance
        self.toAmount = toAmount
        self.toBalance = toBalance
        self.meta = meta
    }

    func swapTokens() {
        swap(&fromToken, &toToken)
        // Keeping mocked amounts as-is for now
    }
}
