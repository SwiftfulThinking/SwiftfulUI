//
//  RedactedViewModifier.swift
//  
//
//  Created by Nick Sarno on 3/30/22.
//

import Foundation
import SwiftUI

@available(iOS 14, *)
struct RedactedViewModifier: ViewModifier {
    
    let isRedacted: Bool
    let style: RedactedStyle
    
    @ViewBuilder func body(content: Content) -> some View {
        switch style {
        case .placeholder:
            content
                .redacted(reason: isRedacted ? .placeholder : [])
        case .opacity:
            content
                .opacity(isRedacted ? 0 : 1)
                .animation(.easeInOut, value: isRedacted)
        case .appear:
            content
                .opacity(isRedacted ? 0 : 1)
        case .none:
            content
        }
    }
    
}

public enum RedactedStyle {
    case placeholder
    case opacity
    case appear
    case none
}

@available(iOS 14, *)
public extension View {
    
    func redacted(if isRedacted: Bool, style: RedactedStyle) -> some View {
        modifier(RedactedViewModifier(isRedacted: isRedacted, style: style))
    }
    
}

@available(iOS 14, *)
struct RedactedView_Previews: PreviewProvider {
    
    struct RedactedView: View {
        
        @State private var isRedacted: Bool = true
        
        var body: some View {
            Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .redacted(if: isRedacted, style: .placeholder)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isRedacted = false
                    }
                }
        }
    }
    
    static var previews: some View {
        RedactedView()
    }
}
