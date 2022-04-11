//
//  RotationGestureViewModifier.swift
//  
//
//  Created by Nick Sarno on 4/10/22.
//

import SwiftUI

struct RotationGestureViewModifier: ViewModifier {
    
    @State var angle: Double = 0
    @State var lastAngle: Double = 0

    let resets: Bool
    let animation: Animation
    let onEnded: ((_ angle: Double) -> ())?

    init(
        resets: Bool,
        animation: Animation,
        onEnded: ((_ angle: Double) -> ())?) {
            self.resets = resets
            self.animation = animation
            self.onEnded = onEnded
    }
        
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: angle + lastAngle))
            .simultaneousGesture(
                RotationGesture()
                    .onChanged { value in
                        angle = value.degrees
                    }
                    .onEnded { value in
                        if !resets {
                            onEnded?(lastAngle)
                        } else {
                            onEnded?(value.degrees)
                        }
                        
                        withAnimation(.spring()) {
                            if resets {
                                angle = 0
                            } else {
                                lastAngle += angle
                                angle = 0
                            }
                        }
                    }
            )
    }
}

public extension View {
    
    /// Add a RotationGesture to a View.
    ///
    /// RotationGesture is added as a simultaneousGesture, to not interfere with other gestures Developer may add.
    ///
    /// - Parameters:
    ///   - resets: If the View should reset to starting state onEnded.
    ///   - animation: The drag animation.
    ///   - onEnded: The modifier will handle the View's offset onEnded. This escaping closure is for Developer convenience.
    ///
    func withRotationGesture(
        resets: Bool = true,
        animation: Animation = .spring(),
        onEnded: ((_ angle: Double) -> ())? = nil) -> some View {
            modifier(RotationGestureViewModifier(resets: resets, animation: animation, onEnded: onEnded))
    }
    
}

struct RotationGestureViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello, world!")
                .padding(50)
                .padding(.horizontal)
                .background(Color.blue)
                .cornerRadius(10)
//                .withRotationGesture()
                .withRotationGesture(resets: false, animation: .spring()) { angle in
                    
                }
        }
    }
}
