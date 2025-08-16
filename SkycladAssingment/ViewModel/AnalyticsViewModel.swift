//
//  AnalyticsViewModel.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

final class AnalyticsViewModel: ObservableObject {
    @Published var timeRange: TimeRange = .m6 { didSet { generateSeries() } }
    @Published var series: [PricePoint] = []
    @Published var selectedPoint: PricePoint?
    @Published var coins: [CoinSummary] = []
    @Published var txns: [TransactionRow] = []
    @Published var showINR: Bool = true
    
    var portfolioValue: Double { series.last?.value ?? 0 }
    
    var btcPriceINR: Double {
        coins.first(where: { $0.symbol.uppercased() == "BTC" })?.price ?? 0
    }
    
    var portfolioValueBTC: Double {
        guard btcPriceINR > 0 else { return 0 }
        return portfolioValue / btcPriceINR
    }
    
    // demo data
    init() {
        coins = [
            .init(name: "Bitcoin", symbol: "BTC", price: 7_562_502.14, changePct: 3.2, icon: "bitcoinsign.circle.fill"),
            .init(name: "Ether",   symbol: "ETH", price:   179_102.50, changePct: 2.8, icon: "e.circle.fill")
        ]
        txns = [
            .init(title: "Receive", token: "BTC", isIncoming: true,  amount: 0.012, date: .now),
            .init(title: "Swap",    token: "ETH", isIncoming: false, amount: 0.25,  date: .now.addingTimeInterval(-86400)),
            .init(title: "Send",    token: "BTC", isIncoming: false, amount: 0.004, date: .now.addingTimeInterval(-86400)),
        ]
        generateSeries()
    }
    
    
    func generateSeries() {
        var points: [PricePoint] = []
        let n = timeRange.points
        var current = 120_000.0
        let start = Date().addingTimeInterval(-Double(n) * 3600 * 12)
        for i in 0..<n {
            // gentle trend with noise
            let drift = Double.random(in: -40000...40000)
            current = max(10_000, current + drift)
            let d = Calendar.current.date(byAdding: .hour, value: i*12, to: start) ?? Date()
            points.append(.init(date: d, value: current))
        }
        series = points
        selectedPoint = points.dropLast().last
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
    
    func formattedPortfolioValue(showINR: Bool) -> String {
        showINR ? formatINR(portfolioValue) : formatBTC(portfolioValueBTC)
    }
    
    func pctString(_ p: Double) -> String {
        let sign = p >= 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", p))%"
    }
}
