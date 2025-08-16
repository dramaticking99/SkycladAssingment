//
//  Tabs.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

enum MainTab: String, CaseIterable, Identifiable {
    case analytics, exchange, record, wallet

    var id: Self { self }

    var title: String {
        switch self {
        case .analytics: return "Analytics"
        case .exchange:  return "Exchange"
        case .record:    return "Record"
        case .wallet:    return "Wallet"
        }
    }

    var icon: String {
        switch self {
        case .analytics: return "chart.line.uptrend.xyaxis"
        case .exchange:  return "arrow.left.arrow.right"
        case .record:    return "list.dash.header.rectangle"
        case .wallet:    return "wallet.bifold"
        }
    }
}
