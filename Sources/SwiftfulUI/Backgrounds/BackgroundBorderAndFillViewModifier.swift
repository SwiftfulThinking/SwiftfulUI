//
//  BackgroundBorderAndFillViewModifier.swift
//  
//
//  Created by Nick Sarno on 4/3/22.
//

import SwiftUI

struct BackgroundBorderAndFillViewModifier: ViewModifier {
    
    let backgroundColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(Color.white.opacity(0.0001))
            .padding(-borderWidth)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius - (borderWidth / 2))
                    .fill(backgroundColor)
            )
            .padding(borderWidth)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(borderColor)
            )
    }
    
}

public extension View {
    
    /// Add a colored border to the background.
    func withBackgroundAndBorder(
        backgroundColor: Color,
        borderColor: Color,
        borderWidth: CGFloat,
        cornerRadius: CGFloat = 0) -> some View {
        modifier(BackgroundBorderAndFillViewModifier(backgroundColor: backgroundColor, borderColor: borderColor, borderWidth: borderWidth, cornerRadius: cornerRadius))
    }
    
}

struct BackgroundBorderAndFillViewModifier_Previews: PreviewProvider {
    
    struct PreviewView: View {
        @State private var isActive: Bool = false
        var body: some View {
            Text("Hello, world")
                .frame(width: 100, height: 100)
                .withBackgroundAndBorder(
                    backgroundColor: .blue,
                    borderColor: isActive ? .red : .blue,
                    borderWidth: 5, cornerRadius: 10)
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
