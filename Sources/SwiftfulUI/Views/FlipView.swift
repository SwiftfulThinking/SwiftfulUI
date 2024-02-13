//
//  FlipView.swift
//
//
//  Created by Nick Sarno on 2/13/24.
//

import SwiftUI

public struct FlipView<FrontView:View, BackView:View>: View {
    
    @Binding private var isFlipped: Bool
    @ViewBuilder private var frontView: FrontView
    @ViewBuilder private var backView: BackView
    let animation: Animation
    
    /// - Parameters:
    ///   - isFlipped:
    ///   - animation: ANIMATION WORKS BEST WITH SYMMETRICAL TIMING (ie. .linear, .easeInOut, etc)
    ///   - frontView:
    ///   - backView:
    public init(
        isFlipped: Binding<Bool>,
        animation: Animation = .easeInOut(duration: 0.2),
        @ViewBuilder frontView: () -> FrontView,
        @ViewBuilder backView: () -> BackView
    ) {
        self._isFlipped = isFlipped
        self.animation = animation
        self.frontView = frontView()
        self.backView = backView()
    }
    
    public var body: some View {
        ZStack {
            frontView
//                .background(
//                    RoundedRectangle(cornerRadius: 32)
//                        .shadow(color: Color.black.opacity(0.125), radius: 4, x: 0, y: 4)
//                )
                .modifier(FlipOpacity(percentage: isFlipped ? 0 : 1))
                .rotation3DEffect(.degrees(isFlipped ? 180 : 360), axis: (0,1,0))
            
            backView
//                .background(
//                    RoundedRectangle(cornerRadius: 32)
//                        .shadow(color: Color.black.opacity(0.125), radius: 4, x: 0, y: 4)
//                )
                .modifier(FlipOpacity(percentage: isFlipped ? 1 : 0))
                .rotation3DEffect(.degrees(isFlipped ? 0 : 180), axis: (0,1,0))
        }
        .animation(animation, value: isFlipped)
    }
}

fileprivate struct FlipOpacity: AnimatableModifier {
    
    var percentage: CGFloat = 0
    
    var animatableData: CGFloat {
        get {
            percentage
        }
        set {
            percentage = newValue
        }
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(Double(percentage.rounded()))
    }
    
}

fileprivate struct FlipPreview: View {
    
    @State private var isFlipped: Bool = false
    
    var body: some View {
        FlipView(
            isFlipped: $isFlipped,
            animation: .easeInOut(duration: 0.5),
            frontView: {
                Rectangle()
                    .fill(Color.red)
                    .cornerRadius(32)
                    .padding(.vertical, 40)
            },
            backView: {
                Rectangle()
                    .fill(Color.blue)
                    .cornerRadius(32)
                    .padding(.vertical, 40)
            }
        )
        .onTapGesture {
            isFlipped.toggle()
        }
    }
}

#Preview {
    FlipPreview()
        .padding(40)
}
