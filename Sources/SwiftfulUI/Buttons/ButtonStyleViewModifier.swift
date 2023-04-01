//
//  SwiftUIView.swift
//  
//
//  Created by Nick Sarno on 4/8/22.
//

import SwiftUI

struct ButtonStyleViewModifier: ButtonStyle {
    
    let scale: CGFloat
    let opacity: Double
    let brightness: Double
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(configuration.isPressed ? opacity : 1)
            .brightness(configuration.isPressed ? brightness : 0)
    }
    
//    Note: Can add onChange to let isPressed value escape.
//    However, requires iOS 14 is not common use case.
//    Ignoring for now.
//        .onChange(of: configuration.isPressed) { newValue in
//          isPressed?(newValue)
//        }

}

public enum ButtonType {
    case press, opacity, tap
}

public extension View {
    
    /// Wrap a View in a Button and add a custom ButtonStyle.
    func asButton(scale: CGFloat = 0.95, opacity: Double = 1, brightness: Double = 0, action: @escaping @MainActor () -> Void) -> some View {
        Button(action: action) {
            self
        }
        .buttonStyle(ButtonStyleViewModifier(scale: scale, opacity: opacity, brightness: brightness))
    }
    
    @MainActor
    @ViewBuilder
    func asButton(_ type: ButtonType = .tap, action: @escaping @MainActor () -> Void) -> some View {
        switch type {
        case .press:
            self.asButton(scale: 0.975, action: action)
        case .opacity:
            self.asButton(scale: 1, opacity: 0.85, action: action)
        case .tap:
            self.onTapGesture {
                action()
            }
        }
    }
    
}

@available(iOS 14, *)
public extension View {
    
    /// Wrap a View in a Link and add a custom ButtonStyle.
    @ViewBuilder
    func asWebLink(scale: CGFloat = 0.95, opacity: Double = 1, brightness: Double = 0, url: @escaping () -> URL?) -> some View {
        if let url = url() {
            Link(destination: url) {
                self
            }
            .buttonStyle(ButtonStyleViewModifier(scale: scale, opacity: opacity, brightness: brightness))
        } else {
            self
        }
    }
    
}

@available(iOS 14, *)
struct ButtonStyleViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello")
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal)
                .background(Color.blue)
                .cornerRadius(10)
                .asButton {
                    
                }
            
            Text("Hello")
                .withFont(font: .headline, color: .white)
                .padding()
                .padding(.horizontal)
                .withBackground(color: .red, cornerRadius: 10)
                .asWebLink {
                    URL(string: "https://www.google.com")
                }
        }
    }
}
