//
//  ExchangeViewModel.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 15/08/25.
//

import SwiftUI

final class ExchangeViewModel: ObservableObject {
    @Published var showINR: Bool = true
    @Published var coins: [CoinSummary] = []
    @Published var txns: [TransactionRow] = []

    @Published var balanceINR: Double
    @Published var changeINR: Double
    @Published var changePct: Double

    @Published var lastAction: QuickAction? = nil
    enum QuickAction { case receive, newTrade, send }

    // demo data
    init(
        balanceINR: Double = 157_342.05,
        changeINR: Double = 1_342,
        changePct: Double = 4.6
    ) {
        self.balanceINR = balanceINR
        self.changeINR = changeINR
        self.changePct = changePct

        // Demo coins (same vibe as Analytics VM)
        self.coins = [
            .init(name: "Bitcoin", symbol: "BTC", price: 7_562_502.14, changePct: 3.2, icon: "bitcoinsign.circle.fill"),
            .init(name: "Ether",   symbol: "ETH", price:   179_102.50, changePct: 2.8, icon: "e.circle.fill")
        ]

        // Demo transactions (recent 3 days)
        let today = Date()
        self.txns = [
            .init(title: "Receive", token: "BTC", isIncoming: true,  amount: 0.002126,  date: today.addingTimeInterval(-1*24*3600)),
            .init(title: "Sent",    token: "ETH", isIncoming: false, amount: 0.003126,  date: today.addingTimeInterval(-2*24*3600)),
            .init(title: "Send",    token: "LTC", isIncoming: false, amount: 0.02126,   date: today.addingTimeInterval(-3*24*3600)),
            .init(title: "Receive", token: "BTC", isIncoming: true,  amount: 0.002126,  date: today.addingTimeInterval(-1*24*3600)),
            .init(title: "Sent",    token: "ETH", isIncoming: false, amount: 0.003126,  date: today.addingTimeInterval(-2*24*3600)),
            .init(title: "Send",    token: "LTC", isIncoming: false, amount: 0.02126,   date: today.addingTimeInterval(-3*24*3600))
        ]
    }

    var currencyTag: String { showINR ? "INR" : "BTC" }

    var btcPriceINR: Double {
        coins.first(where: { $0.symbol.uppercased() == "BTC" })?.price ?? 0
    }

    var balanceBTC: Double {
        guard btcPriceINR > 0 else { return 0 }
        return balanceINR / btcPriceINR
    }

    var changeBTC: Double {
        guard btcPriceINR > 0 else { return 0 }
        return changeINR / btcPriceINR
    }

    private let inrFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "en_IN")
        f.currencySymbol = "₹"
        f.maximumFractionDigits = 2
        return f
    }()

    private let btcFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.usesGroupingSeparator = true
        f.maximumFractionDigits = 8
        f.minimumFractionDigits = 2
        return f
    }()

    func formatINR(_ value: Double) -> String {
        inrFormatter.string(from: NSNumber(value: value)) ?? "₹\(value)"
    }

    func formatBTC(_ value: Double) -> String {
        let body = btcFormatter.string(from: NSNumber(value: value)) ?? String(format: "%.8f", value)
        return "₿ \(body)"
    }

    func pctString(_ p: Double) -> String {
        let sign = p >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", p))%"
    }

    // Header helpers
    func formattedBalance() -> String {
        showINR ? formatINR(balanceINR) : formatBTC(balanceBTC)
    }

    func formattedDeltaAmount() -> String {
        showINR ? formatINR(changeINR) : formatBTC(changeBTC)
    }

    func receiveTapped()  { lastAction = .receive  }
    func newTradeTapped() { lastAction = .newTrade }
    func sendTapped()     { lastAction = .send     }
}
