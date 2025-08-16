//
//  RecentTransactionsSection.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

struct RecentTransactionsSection: View {
    let rows: [TransactionRow]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Recent Transactions")
                .font(.geistMono(14, wght: 400))
                .foregroundStyle(.white.opacity(0.9))

            VStack(spacing: 8) {
                ForEach(rows) { r in
                    TransactionRowView(r: r)
                }
            }
        }
    }
}

private let txDateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateFormat = "d MMMM" // e.g. 20 March
    return f
}()

struct TransactionRowView: View {
    let r: TransactionRow
    
    var body: some View {
        HStack(spacing: 12) {
            // Leading icon (rounded square)
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.white.opacity(0.14), .white.opacity(0.06)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .overlay(
                    Image(systemName: r.isIncoming ? "arrow.down.left" : "arrow.up.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                )
                .frame(width: 44, height: 44)
            
            // Title + date
            VStack(alignment: .leading, spacing: 4) {
                Text(r.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.95))
                Text(txDateFormatter.string(from: r.date))
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer(minLength: 12)
            
            // Token + amount
            VStack(alignment: .trailing, spacing: 4) {
                Text(r.token)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
                Text("\(r.isIncoming ? "+" : "-")\(String(format: "%.6f", r.amount))")
                    .font(.subheadline.monospacedDigit().weight(.semibold))
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 84)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.panel)
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}
