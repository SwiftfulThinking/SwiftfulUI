//
//  SwiftUIView.swift
//  
//
//  Created by Nick Sarno on 4/8/22.
//

import SwiftUI

struct ButtonStyleViewModifier: ButtonStyle {
    
    let scale: CGFloat
    let opacity: Double
    let brightness: Double
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(configuration.isPressed ? opacity : 1)
            .brightness(configuration.isPressed ? brightness : 0)
    }
    
//    Note: Can add onChange to let isPressed value escape.
//    However, requires iOS 14 is not common use case.
//    Ignoring for now.
//        .onChange(of: configuration.isPressed) { newValue in
//          isPressed?(newValue)
//        }

}

public extension View {
    
    /// Wrap a View in a Button and add a custom ButtonStyle.
    func asPressableButton(
        scale: CGFloat = 0.95,
        opacity: Double = 1,
        brightness: Double = 0,
        action: @escaping () -> Void) -> some View {
        Button(action: action) {
            self
        }
        .buttonStyle(ButtonStyleViewModifier(scale: scale, opacity: opacity, brightness: brightness))
    }
    
}

struct ButtonStyleViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello")
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal)
                .background(Color.blue)
                .cornerRadius(10)
                .asPressableButton {
                    
                }
        }
    }
}
