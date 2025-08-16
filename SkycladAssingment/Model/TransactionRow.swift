//
//  TransactionRow.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

struct TransactionRow: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let token: String
    let isIncoming: Bool
    let amount: Double
    let date: Date
}
