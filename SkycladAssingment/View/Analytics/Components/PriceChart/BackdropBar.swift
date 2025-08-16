//
//  BackDropBar.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 14/08/25.
//

import Foundation

struct BackdropBar: Identifiable, Equatable {
    let center: Date
    let value: Double
    var id: Date { center }

    static func make(from pts: [PricePoint], buckets: Int) -> [BackdropBar] {
        guard pts.count > 1, buckets > 0 else { return [] }
        let sorted = pts.sorted { $0.date < $1.date }
        let t0 = sorted.first!.date.timeIntervalSinceReferenceDate
        let t1 = sorted.last!.date.timeIntervalSinceReferenceDate
        let step = (t1 - t0) / Double(buckets)

        var bars: [BackdropBar] = []
        bars.reserveCapacity(buckets)

        for i in 0..<buckets {
            let a = t0 + Double(i) * step
            let b = t0 + Double(i + 1) * step
            let bin = sorted.filter {
                let t = $0.date.timeIntervalSinceReferenceDate
                return t >= a && t < b
            }
            let v = bin.isEmpty
                ? (bars.last?.value ?? sorted.first!.value)
                : bin.map(\.value).reduce(0, +) / Double(bin.count)

            let center = Date(timeIntervalSinceReferenceDate: (a + b) / 2)
            bars.append(.init(center: center, value: v))
        }
        return bars
    }
}
