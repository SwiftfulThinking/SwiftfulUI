//
//  BackgroundLinearGradientFillViewModifier.swift
//  
//
//  Created by Nick Sarno on 4/3/22.
//

import SwiftUI

struct BackgroundLinearGradientFillViewModifier: ViewModifier {
    
    let isActive: Bool
    let activeGradient: LinearGradient
    let defaultGradient: LinearGradient?
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
    
    /// Add a linear gradient background.
    func withGradientBackground(
        gradient: LinearGradient,
        cornerRadius: CGFloat = 0) -> some View {
        modifier(BackgroundLinearGradientFillViewModifier(isActive: true, activeGradient: gradient, defaultGradient: nil, cornerRadius: cornerRadius))
    }
    
    /// Add a linear gradient background that can animate between gradients.
    func withGradientBackgroundAnimatable(
        isActive: Bool,
        activeGradient: LinearGradient,
        defaultGradient: LinearGradient,
        cornerRadius: CGFloat = 0) -> some View {
        modifier(BackgroundLinearGradientFillViewModifier(isActive: isActive, activeGradient: activeGradient, defaultGradient: defaultGradient, cornerRadius: cornerRadius))
    }
    
}

struct BackgroundLinearGradientFillViewModifier_Previews: PreviewProvider {
    
    struct PreviewView: View {
        @State private var isActive: Bool = false
        var body: some View {
            Text("Hello, world")
                .padding()
                .withGradientBackgroundAnimatable(isActive: isActive, activeGradient: LinearGradient(colors: [Color.red, .blue], startPoint: .leading, endPoint: .trailing), defaultGradient: LinearGradient(colors: [Color.green, .orange], startPoint: .leading, endPoint: .trailing), cornerRadius: 10)
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
