//
//  PricePoint.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

struct PricePoint: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let value: Double
}
