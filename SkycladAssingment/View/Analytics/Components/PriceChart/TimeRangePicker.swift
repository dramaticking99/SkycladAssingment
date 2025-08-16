//
//  TimeRangePicker.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

struct TimeRangePicker: View {
    @Binding var selected: TimeRange

    var body: some View {
        HStack(spacing: 8) {                           // gap between items
            ForEach(TimeRange.allCases) { range in
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selected = range
                    }
                } label: {
                    // Capsule hugs the text only…
                    Text(range.display)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(selected == range ? .textFront : .textBack)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(
                            Capsule(style: .continuous)
                                .fill(selected == range ? .panel : .clear)
                        )
                        // …but each item gets an equal-width slot
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())     // full slot is tappable
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)                       // 16 left/right
    }
}
