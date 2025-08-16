//
//  ChartCallout.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 14/08/25.
//

import SwiftUI

struct ChartCalloutView: View {
    let date: Date
    let value: Double
    let dateFormatter: DateFormatter
    let numberFormatter: NumberFormatter
    var onSizeChange: (CGSize) -> Void = { _ in }

    private struct CalloutSizeKey: PreferenceKey {
        static var defaultValue: CGSize = .zero
        static func reduce(value: inout CGSize, nextValue: () -> CGSize) { value = nextValue() }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(dateFormatter.string(from: date))
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.textBack)
            Text(numberFormatter.string(from: NSNumber(value: value)) ?? "\(value)")
                .font(.callout.weight(.semibold))
                .foregroundStyle(.textFront)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .background(
            GeometryReader { g in
                Color.clear.preference(key: CalloutSizeKey.self, value: g.size)
            }
        )
        .onPreferenceChange(CalloutSizeKey.self, perform: onSizeChange)
        .allowsHitTesting(false)
    }
}
