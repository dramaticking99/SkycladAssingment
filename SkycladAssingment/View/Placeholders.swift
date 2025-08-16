//
//  Placeholders.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

struct RecordView: View { var body: some View {
    ScrollView { VStack(spacing: 24) { Text("Record").font(.title).foregroundStyle(.white); demoCard } }
    .padding().background(Color.black.ignoresSafeArea())
}}

struct WalletView: View { var body: some View {
    ScrollView { VStack(spacing: 24) { Text("Wallet").font(.title).foregroundStyle(.white); demoCard } }
    .padding().background(Color.black.ignoresSafeArea())
}}

private var demoCard: some View {
    RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(.ultraThinMaterial)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.15), lineWidth: 1))
        .frame(height: 160)
        .shadow(color: .black.opacity(0.35), radius: 18, y: 8)
        .padding(.horizontal)
}
