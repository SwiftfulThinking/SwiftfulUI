//
//  OnFirstAppearViewModifier.swift
//  
//
//  Created by Nick Sarno on 11/11/23.
//

import Foundation
import SwiftUI

struct OnFirstAppearViewModifier: ViewModifier {
    
    @State private var didAppear: Bool = false
    let action: @MainActor () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !didAppear else { return }
                didAppear = true
                action()
            }
    }
}

extension View {
    
    public func onFirstAppear(action: @MainActor @escaping () -> Void) -> some View {
        modifier(OnFirstAppearViewModifier(action: action))
    }
}

