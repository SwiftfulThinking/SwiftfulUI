//
//  FontAnimateableViewModifier.swift
//  
//
//  Created by Nick Sarno on 4/3/22.
//

import SwiftUI

struct FontAnimateableViewModifier: ViewModifier {
    
    let font: Font
    let color: Color
    let lineLimit: Int?
    let minimumScaleFactor: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(Color.white)
            .colorMultiply(color)
            .lineLimit(lineLimit)
            .minimumScaleFactor(minimumScaleFactor)
    }
}

public extension View {
    
    /// Convenience method for adding font-related modifiers that supports animating text color.
    func withFontAnimateable(font: Font, color: Color, lineLimit: Int? = nil, minimumScaleFactor: CGFloat = 1) -> some View {
        modifier(FontAnimateableViewModifier(font: font, color: color, lineLimit: lineLimit, minimumScaleFactor: minimumScaleFactor))
    }
    
}

struct FontAnimateableViewModifier_Previews: PreviewProvider {
    
    struct PreviewView: View {
        @State private var isActive: Bool = false
        var body: some View {
            Text("Animate color on tap!")
                .withFontAnimateable(font: .headline, color: isActive ? Color.red : .blue)
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
