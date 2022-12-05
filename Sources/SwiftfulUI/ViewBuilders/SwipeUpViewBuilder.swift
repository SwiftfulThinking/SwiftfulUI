//
//  SwipeUpViewBuilder.swift
//  
//
//  Created by Nick Sarno on 6/10/22.
//

import SwiftUI

@available(iOS 14, *)
public struct SwipeUpViewBuilder<FullScreenView:View, CollapsedView: View>: View {
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    let fullContent: () -> FullScreenView
    let shortContent: () -> CollapsedView
    let dragThreshold: CGFloat
    let backgroundColor: Color?
    let animation: Animation
    let animateOpacity: Bool
    let collapsedViewHeight: CGFloat
    
    @Binding private var isFullScreen: Bool
    @State private var dragOffset: CGSize = .zero
    
    public init(isFullScreen: Binding<Bool>, dragThreshold: CGFloat = 35, backgroundColor: Color? = nil, animation: Animation = .easeInOut, animateOpacity: Bool = true, collapsedViewHeight: CGFloat = 55, @ViewBuilder fullScreenView: @escaping () -> FullScreenView, @ViewBuilder collapsedView: @escaping () -> CollapsedView) {
        self.fullContent = fullScreenView
        self.shortContent = collapsedView
        self.dragThreshold = dragThreshold
        self.animation = animation
        self.animateOpacity = animateOpacity
        self.collapsedViewHeight = collapsedViewHeight
        self.backgroundColor = backgroundColor
        self._isFullScreen = isFullScreen
    }
    
    public var body: some View {
        Rectangle()
            .fill(Color.clear)
            .ignoresSafeArea()
            .overlay(
                swipeUpViewBuilder
                
                ,alignment: .top
            )
    }
    
    public var swipeUpViewBuilder: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.black.opacity(0.001))
                    .overlay(
                        ZStack {
                            if let backgroundColor = backgroundColor {
                                backgroundColor
                                    .frame(minHeight: 200, alignment: .top)
                            }
                        }
                        , alignment: .top)
                    .ignoresSafeArea()
                    .overlay(
                        fullContent()
                            .frame(minHeight: 200, alignment: .top)
//                            .opacity(fullContentOpacity)
                             , alignment: .top)

            }
            
            shortContent()
                .opacity(shortContentOpacity)

        }
        .frame(height: height, alignment: .bottom)
        .animation(animation, value: dragOffset)
        .animation(animation, value: isFullScreen)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged({ value in
                    self.dragOffset = value.translation
                })
                .onEnded({ value in
                    self.dragOffset = value.translation

                    if isFullScreen {
                        if swipeDownIsAcrossThreshold {
                            withAnimation(animation) {
                                isFullScreen = false
                            }
                        }
                    } else {
                        if swipeUpIsAcrossThreshold {
                            withAnimation(animation) {
                                isFullScreen = true
                            }
                        }
                    }

                    withAnimation(animation) {
                        self.dragOffset = .zero
                    }
                })
        )
    }
    
    private var height: CGFloat? {
        if isFullScreen {
            if isDragging {
                return UIScreen.main.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom - dragOffset.height
            } else {
                return nil
            }
        } else {
            return collapsedViewHeight - dragOffset.height
        }
    }
    
    private var isDragging: Bool {
        dragOffset != .zero
    }
    
    private var swipeDownIsAcrossThreshold: Bool {
        dragOffset.height > dragThreshold
    }
    
    private var swipeUpIsAcrossThreshold: Bool {
        dragOffset.height < -dragThreshold
    }
    
    private var dragPercentage: Double {
        abs(dragOffset.height) / (UIScreen.main.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom)
    }
    
    private var shortContentOpacity: CGFloat {
        guard animateOpacity else { return 1 }
        
        if !isDragging {
            return isFullScreen ? 0 : 1
        }
        
        if isFullScreen {
            return dragPercentage
        } else {
            return 1 - dragPercentage
        }
    }
    
//    private var fullContentOpacity: CGFloat {
//        guard animateOpacity else { return 1 }
//
//        if !isDragging {
//            return isFullScreen ? 1 : 0
//        }
//
//        if isFullScreen {
//            return 1 - dragPercentage
//        } else {
//            return dragPercentage
//        }
//    }
    
}

@available(iOS 14, *)
struct SwipeUpViewBuilder_Previews: PreviewProvider {
    
    struct PreviewView: View {
        @State private var isFullScreen: Bool = false
        var body: some View {
            ZStack(alignment: .bottom) {
                Text(" ")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.yellow)
                
                
                SwipeUpViewBuilder(isFullScreen: $isFullScreen, dragThreshold: 50, backgroundColor: .black, animateOpacity: true, collapsedViewHeight: 50) {
                    Rectangle()
                        .fill(Color.green)
//                        .frame(height: 700)
                } collapsedView: {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 50)
                        .offset(x: 50)
                }

                Rectangle()
                    .fill(Color.red)
                    .frame(height: 50)
                    .offset(x: 100)
            }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
