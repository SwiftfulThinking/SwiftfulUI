//
//  BackgroundBorderAndRadialGradientFillViewModifier.swift
//  
//
//  Created by Nick Sarno on 4/3/22.
//


import SwiftUI

struct BackgroundBorderAndRadialGradientFillViewModifier: ViewModifier {
    
    let isActive: Bool
    let borderGradient: RadialGradient
    let borderWidth: CGFloat
    let backgroundColor: Color
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(Color.white.opacity(0.0001))
            .padding(-borderWidth)
            .background(
                ZStack {
                    if !isActive {
                        RoundedRectangle(cornerRadius: cornerRadius - (borderWidth / 2))
                            .fill(backgroundColor)
                    }
                }
            )
            .padding(borderWidth)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(borderGradient)
            )
    }
    
}
public extension View {
    
    /// Add a Radial gradient border and animate as the background if needed.
    func withBackgroundAndBorder_RadialGradient(
        isActive: Bool = false,
        borderGradient: RadialGradient,
        borderWidth: CGFloat,
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 0) -> some View {
        modifier(BackgroundBorderAndRadialGradientFillViewModifier(isActive: isActive, borderGradient: borderGradient, borderWidth: borderWidth, backgroundColor: backgroundColor, cornerRadius: cornerRadius))
    }
        
}

struct BackgroundBorderAndRadialGradientFillViewModifier_Previews: PreviewProvider {
    
    struct PreviewView: View {
        @State private var isActive: Bool = false
        var body: some View {
            Text("Hello, world")
                .frame(width: 100, height: 100)
                .withBackgroundAndBorder_RadialGradient(
                    isActive: isActive,
                    borderGradient: RadialGradient(colors: [.blue, .red], center: .center, startRadius: 0, endRadius: 100), borderWidth: 10, cornerRadius: 15)
                .onTapGesture {
                    withAnimation {
                        isActive.toggle()
                    }
                }
        }
    }
    
    static var previews: some View {
        VStack {
            PreviewView()
            
            Text("Hello, world")
                .frame(width: 100, height: 100)
                .background(Color.orange)
        }
    }
}
