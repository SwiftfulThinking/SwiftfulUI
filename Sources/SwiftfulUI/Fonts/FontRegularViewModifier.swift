//
//  FontRegularViewModifier.swift
//  
//
//  Created by Nick Sarno on 4/3/22.
//

import SwiftUI

struct FontRegularViewModifier: ViewModifier {
    
    let font: Font
    let color: Color
    let lineLimit: Int?
    let minimumScaleFactor: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .lineLimit(lineLimit)
            .minimumScaleFactor(minimumScaleFactor)
    }
}

public extension View {
    
    /// Convenience method for adding font-related modifiers.
    func withFont(font: Font, color: Color, lineLimit: Int? = nil, minimumScaleFactor: CGFloat = 1) -> some View {
        modifier(FontRegularViewModifier(font: font, color: color, lineLimit: lineLimit, minimumScaleFactor: minimumScaleFactor))
    }
    
}

struct FontRegularViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, world.")
            .withFont(font: .headline, color: .red, lineLimit: 1, minimumScaleFactor: 1)
    }
}
