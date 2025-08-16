//
//  TimeRange.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

enum TimeRange: String, CaseIterable, Identifiable {
    case h1 = "1h", h8 = "8h", d1 = "1d", w1 = "1w", m1 = "1m", m6 = "6m", y1 = "1y"
    var id: Self { self }
    var display: String { rawValue }
    var points: Int {
        switch self {
        case .h1: return 8
        case .h8: return 8
        case .d1: return 8
        case .w1: return 8
        case .m1: return 8
        case .m6: return 8
        case .y1: return 8
        }
    }
}
