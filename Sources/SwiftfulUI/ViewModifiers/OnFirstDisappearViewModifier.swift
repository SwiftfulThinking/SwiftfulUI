//
//  OnFirstDisappearViewModifier.swift
//  
//
//  Created by Ricky Stone on 12/11/2023.
//

import Foundation
import SwiftUI

struct OnFirstDisappearViewModifier: ViewModifier {
    
    @State private var didDisappear: Bool = false
    let action: @MainActor () -> Void
    
    func body(content: Content) -> some View {
        content
            .onDisappear {
                guard !didDisappear else { return }
                didDisappear = true
                action()
            }
    }
}

extension View {
    public func onFirstDisappear(perform action: @MainActor @escaping () -> Void) -> some View {
        modifier(OnFirstDisappearViewModifier(action: action))
    }
}
