//
//  FloatingPlusButton.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

struct FloatingPlusButton: View {
    var size: CGFloat = 56
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .bold))
                .frame(width: size, height: size)
                .foregroundStyle(Color.brandBlue)
                .background(
                    Circle()
                        .fill(Color.white)
                        .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 1))
                        .shadow(color: .black.opacity(0.4), radius: 16, y: 8)
                )
        }
        .buttonStyle(.plain)
    }
}
