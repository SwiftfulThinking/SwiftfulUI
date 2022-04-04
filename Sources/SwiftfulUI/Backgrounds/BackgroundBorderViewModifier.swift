//
//  BackgroundBorderViewModifier.swift
//  
//
//  Created by Nick Sarno on 4/3/22.
//

import SwiftUI

struct BackgroundBorderViewModifier: ViewModifier {
    
    let borderColor: Color
    let borderWidth: CGFloat
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(Color.white.opacity(0.0001))
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            )
    }
    
}

public extension View {
    
    /// Add a colored border to the background.
    func withBorder(
        color: Color,
        width: CGFloat,
        cornerRadius: CGFloat = 0) -> some View {
        modifier(BackgroundBorderViewModifier(borderColor: color, borderWidth: width, cornerRadius: cornerRadius))
    }
    
}

struct BackgroundBorderViewModifier_Previews: PreviewProvider {
    
    struct PreviewView: View {
        @State private var isActive: Bool = false
        var body: some View {
            Text("Hello, world")
                .frame(width: 100, height: 100)
                .withBorder(color: isActive ? .blue : .red, width: 2, cornerRadius: 10)
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
