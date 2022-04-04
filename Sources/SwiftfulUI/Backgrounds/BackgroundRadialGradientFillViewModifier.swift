//
//  BackgroundRadialGradientFillViewModifier.swift
//  
//
//  Created by Nick Sarno on 4/3/22.
//

import SwiftUI

struct BackgroundRadialGradientFillViewModifier: ViewModifier {
    
    let isActive: Bool
    let activeGradient: RadialGradient
    let defaultGradient: RadialGradient?
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    if isActive {
                        activeGradient
                            .transition(AnyTransition.opacity.animation(.linear))
                    }
                    if !isActive, let defaultGradient = defaultGradient {
                        defaultGradient
                            .transition(AnyTransition.opacity.animation(.linear))
                    }
                }
            )
            .background(defaultGradient != nil ? Color.gray : .clear)
            .cornerRadius(cornerRadius)
    }
    
}

public extension View {
    
    /// Add a radial gradient background.
    func withBackground_RadialGradient(
        gradient: RadialGradient,
        cornerRadius: CGFloat = 0) -> some View {
        modifier(BackgroundRadialGradientFillViewModifier(isActive: true, activeGradient: gradient, defaultGradient: nil, cornerRadius: cornerRadius))
    }
    
    /// Add a radial gradient background that can animate between gradients.
    func withBackground_RadialGradientAnimatable(
        isActive: Bool,
        activeGradient: RadialGradient,
        defaultGradient: RadialGradient,
        cornerRadius: CGFloat = 0) -> some View {
        modifier(BackgroundRadialGradientFillViewModifier(isActive: isActive, activeGradient: activeGradient, defaultGradient: defaultGradient, cornerRadius: cornerRadius))
    }
    
}

struct BackgroundRadialGradientFillViewModifier_Previews: PreviewProvider {
    
    struct PreviewView: View {
        @State private var isActive: Bool = false
        var body: some View {
            Text("Hello, world")
                .padding(100)
//                .withBackground_RadialGradientAnimatable(isActive: isActive, activeGradient: RadialGradient(colors: [Color.blue, .red], center: .center, startRadius: 1, endRadius: 200), defaultGradient: RadialGradient(colors: [Color.blue, .red], center: .center, startRadius: 100, endRadius: 200), cornerRadius: 10)
                .withBackground_RadialGradient(gradient: RadialGradient(colors: [Color.blue, .yellow, .green], center: .center, startRadius: 1, endRadius: 200), cornerRadius: 20)
                .onTapGesture {
                    withAnimation {
                        isActive.toggle()
                    }
                }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
