//
//  Token.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 16/08/25.
//

import SwiftUI

enum Token {
    case eth, inr
    var title: String { self == .eth ? "ETH" : "INR" }

    @ViewBuilder var symbolView: some View {
        switch self {
        case .eth: Image(systemName: "diamond.fill")
        case .inr: Text("₹").font(.system(size: 14, weight: .black))
        }
    }
}
