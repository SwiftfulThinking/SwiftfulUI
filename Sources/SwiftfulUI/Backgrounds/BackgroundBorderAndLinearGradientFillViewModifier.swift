//
//  BackgroundBorderAndLinearGradientFillViewModifier.swift
//  
//
//  Created by Nick Sarno on 4/3/22.
//

import SwiftUI

struct BackgroundBorderAndLinearGradientFillViewModifier: ViewModifier {
    
    let isActive: Bool
    let borderGradient: LinearGradient
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
    
    /// Add a linear gradient border and animate as the background if needed.
    func withGradientBorder(
        isActive: Bool = false,
        borderGradient: LinearGradient,
        borderWidth: CGFloat,
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 0) -> some View {
        modifier(BackgroundBorderAndLinearGradientFillViewModifier(isActive: isActive, borderGradient: borderGradient, borderWidth: borderWidth, backgroundColor: backgroundColor, cornerRadius: cornerRadius))
    }
    
    
        
}

struct BackgroundBorderAndLinearGradientFillViewModifier_Previews: PreviewProvider {
    
    struct PreviewView: View {
        @State private var isActive: Bool = false
        var body: some View {
            Text("Hello, world")
                .padding(.horizontal)
                .padding(.all)
                .withGradientBorder(
                    isActive: isActive,
                    borderGradient: LinearGradient(colors: [Color.blue.opacity(0.3), .blue], startPoint: .topLeading, endPoint: .trailing), borderWidth: 2, cornerRadius: 15)
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
