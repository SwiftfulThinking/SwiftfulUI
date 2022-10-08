//
//  AnimatableZIndexModifier.swift
//  
//
//  Created by Nick Sarno on 10/7/22.
//

import Foundation
import SwiftUI

struct AnimatableZIndexModifier: ViewModifier, Animatable {
    var index: Double
    func body(content: Content) -> some View {
        content
            .zIndex(index)
    }
}

extension View {
    func animatableZIndex(_ index: Double) -> some View {
        self.modifier(AnimatableZIndexModifier(index: index))
    }
}
