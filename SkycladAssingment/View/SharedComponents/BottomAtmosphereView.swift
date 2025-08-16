//
//  BottomAtmosphereView.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 16/08/25.
//

import SwiftUI

struct BottomAtmosphereView: View {
    var height: CGFloat = 120
    var body: some View {
        LinearGradient(colors: [.brandBlue.opacity(0.55), .clear],
                       startPoint: .bottom, endPoint: .top)
        .background(.ultraThinMaterial)
        .frame(height: height)
        .blur(radius: 24)
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}
