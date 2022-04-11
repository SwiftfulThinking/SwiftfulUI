//
//  MagnificationGestureViewModifier.swift
//  
//
//  Created by Nick Sarno on 4/10/22.
//

import SwiftUI

struct MagnificationGestureViewModifier: ViewModifier {
    
    @State private var scale: CGFloat = 0
    @State private var lastScale: CGFloat = 0

    let resets: Bool
    let animation: Animation
    let scaleMultiplier: CGFloat
    let onEnded: ((_ scale: CGFloat) -> ())?

    init(
        resets: Bool,
        animation: Animation,
        scaleMultiplier: CGFloat,
        onEnded: ((_ scale: CGFloat) -> ())?) {
            self.resets = resets
            self.animation = animation
            self.scaleMultiplier = scaleMultiplier
            self.onEnded = onEnded
    }
        
    func body(content: Content) -> some View {
        content
            .scaleEffect(1 + ((scale + lastScale) * scaleMultiplier))
            .simultaneousGesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = value - 1
                    }
                    .onEnded { value in
                        if !resets {
                            onEnded?(lastScale)
                        } else {
                            onEnded?(value - 1)
                        }
                        
                        withAnimation(animation) {
                            if resets {
                                scale = 0
                            } else {
                                lastScale += scale
                                scale = 0
                            }
                        }
                    }
            )
    }
    
}

public extension View {
    
    /// Add a MagnificationGesture to a View.
    ///
    /// MagnificationGesture is added as a simultaneousGesture, to not interfere with other gestures Developer may add.
    ///
    /// - Parameters:
    ///   - resets: If the View should reset to starting state onEnded.
    ///   - animation: The drag animation.
    ///   - scaleMultiplier: Used to scale the View while dragging.
    ///   - onEnded: The modifier will handle the View's scale onEnded. This escaping closure is for Developer convenience.
    ///
    func withMagnificationGesture(
        resets: Bool = true,
        animation: Animation = .spring(),
        scaleMultiplier: CGFloat = 1,
        onEnded: ((_ scale: CGFloat) -> ())? = nil) -> some View {
            modifier(MagnificationGestureViewModifier(resets: resets, animation: animation, scaleMultiplier: scaleMultiplier, onEnded: onEnded))
    }
    
}

struct MagnificationGestureViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello, world!")
                .padding(50)
                .padding(.horizontal)
                .background(Color.blue)
                .cornerRadius(10)
                .withMagnificationGesture()
                .withMagnificationGesture(resets: false, animation: .spring(), scaleMultiplier: 1.1) { scale in
                    
                }
        }
    }
}

