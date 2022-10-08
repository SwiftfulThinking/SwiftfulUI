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
    
    var animatableData: Double {
      get { index }
      set { index = newValue }
    }
    
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
