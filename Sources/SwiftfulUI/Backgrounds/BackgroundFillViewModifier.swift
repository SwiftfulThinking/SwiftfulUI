//
//  BackgroundFillViewModifier.swift
//  
//
//  Created by Nick Sarno on 4/3/22.
//

import SwiftUI

struct BackgroundFillViewModifier: ViewModifier {
    
    let color: Color
    let cornerRadius: CGFloat
        
    func body(content: Content) -> some View {
        content
            .background(color)
            .cornerRadius(cornerRadius)
    }
    
}

public extension View {
    
    /// Add a color background with corner radius.
    func withBackground(color: Color, cornerRadius: CGFloat = 0) -> some View {
        modifier(BackgroundFillViewModifier(color: color, cornerRadius: cornerRadius))
    }
    
}

struct BackgroundFillViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, world")
            .withBackground(color: .red, cornerRadius: 30)
    }
}
