//
//  ScrollViewWithScrollToLocation.swift
//  
//
//  Created by Nick Sarno on 4/8/22.
//

import SwiftUI

@available(iOS 14, *)
public struct ScrollViewWithScrollToLocation<Content:View>: View {
    
    let axes: Axis.Set
    let showsIndicators: Bool
    let content: Content
    let scrollToLocation: AnyHashable?
    let scrollAnchor: UnitPoint
    let animated: Bool
    
    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = false,
        scrollToLocation: AnyHashable?,
        scrollAnchor: UnitPoint = .center,
        animated: Bool = true,
        @ViewBuilder content: () -> Content) {
            self.axes = axes
            self.showsIndicators = showsIndicators
            self.content = content()
            self.scrollToLocation = scrollToLocation
            self.scrollAnchor = scrollAnchor
            self.animated = animated
        }
    
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            ScrollViewReader { proxy in
                content
                    .onChange(of: scrollToLocation) { newValue in
                        scroll(to: newValue, proxy: proxy)
                    }
            }
        }
    }
    
    private func scroll(to location: AnyHashable?, proxy: ScrollViewProxy) {
        guard let location = location else { return }
        withAnimation(animated ? .default : .none) {
            proxy.scrollTo(location, anchor: scrollAnchor)
        }
    }
}

@available(iOS 14, *)
struct ScrollViewWithScrollToLocation_Previews: PreviewProvider {
    
    struct PreviewView: View {
        
        @State private var scrollToLocation: Int = 0

        var body: some View {
            ScrollViewWithScrollToLocation(scrollToLocation: scrollToLocation) {
                VStack {
                    ForEach(0..<30) { x in
                        Text("x: \(x)")
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .cornerRadius(10)
                            .background(Color.red)
                            .padding()
                            .id(x)
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        scrollToLocation = 16
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        scrollToLocation = 2
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                        scrollToLocation = 29
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                        scrollToLocation = 0
                    }
                }
            }
            .overlay(Text("Scrolling to: \(scrollToLocation)"))
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
