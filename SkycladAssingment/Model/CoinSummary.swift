//
//  CoinSummary.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

struct CoinSummary: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let symbol: String
    let price: Double
    let changePct: Double
    let icon: String
}
