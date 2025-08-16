//
//  GlassIconButton.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

struct GlassIconButton: View {
    var systemName: String
    var size: CGFloat = 44
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: min(22, size * 0.5), weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: size, height: size)
                .background(Color.clear)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
