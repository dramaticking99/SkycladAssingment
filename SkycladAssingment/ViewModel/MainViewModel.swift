//
//  MainViewModel.swift
//  SkycladAssingment
//
//  Created by Chetan Sanwariya on 13/08/25.
//

import SwiftUI

final class MainViewModel: ObservableObject {
    @Published var selectedTab: MainTab = .analytics
    @Published var showPlusButton: Bool = true
    @Published var isPresentingPerformExchange: Bool = false
    
    func setPlusVisible(_ visible: Bool) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            showPlusButton = visible
        }
    }
    
    func didTapPlus() {
        isPresentingPerformExchange = true
    }
}
