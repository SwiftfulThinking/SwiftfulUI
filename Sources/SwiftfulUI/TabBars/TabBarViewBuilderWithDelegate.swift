//
//  TabBarViewBuilderWithDelegate.swift
//  
//
//  Created by Nick Sarno on 6/13/22.
//

import SwiftUI

public protocol TabBarDelegate {
    var hideTabBar: Bool { get set }
    var hideHoverBar: Bool { get set }
}

@available(iOS 14, *)
public struct TabBarViewBuilderWithDelegate<Content:View, TabBar: View, HoverBar: View>: View {
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    let delegate: TabBarDelegate?
    let content: Content
    let tabBar: TabBar
    let hoverView: HoverBar
    
    @State private var tabBarFrame: CGRect = .zero
    @State private var hoverFrame: CGRect = .zero

    public init(
        delegate: TabBarDelegate?,
        @ViewBuilder content: () -> Content,
        @ViewBuilder tabBar: () -> TabBar,
        @ViewBuilder hoverBar: () -> HoverBar) {
            self.delegate = delegate
            self.content = content()
            self.tabBar = tabBar()
            self.hoverView = hoverBar()
        }

    public var body: some View {
        TabBarViewBuilder(style: .zStack) {
            content
        } tabBar: {
            tabBar
                .offset(y: tabBarOffset)
                .readingFrame { frame in
                    tabBarFrame = frame
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .background(
                    hoverView
                        .offset(y: hoverBarOffset)
                        .readingFrame { frame in
                            hoverFrame = frame
                        }
                ,alignment: .bottom)
                .animation(.easeInOut, value: delegate?.hideTabBar)
                .animation(.easeInOut, value: delegate?.hideHoverBar)
        }
    }
    
    private var tabBarOffset: CGFloat {
        guard let delegate = delegate, delegate.hideTabBar else {
            return 0
        }
        
        return tabBarFrame.height + safeAreaInsets.bottom
    }
    
    private var hoverBarOffset: CGFloat {
        guard let delegate = delegate, (delegate.hideTabBar || delegate.hideHoverBar) else {
            return -tabBarFrame.height
        }
        
        if delegate.hideTabBar && delegate.hideHoverBar {
            return tabBarFrame.height + safeAreaInsets.bottom
        } else if delegate.hideTabBar {
            return 0
        } else if delegate.hideHoverBar {
            return hoverFrame.height - tabBarFrame.height
        }
        
        return 0 // Should never execute
    }
}

@available(iOS 14, *)
struct TabBarViewBuilderWithDelegate_Previews: PreviewProvider {
    
    class TBDelegate: ObservableObject, TabBarDelegate {
        @Published var hoverIsFullScreen: Bool = false
        @Published var hideTabBar: Bool = false
        @Published var hideHoverBar: Bool = false
    }
    
    struct PreviewView: View {
        @State var selection: TabBarItem = TabBarItem(title: "Home", iconName: "heart.fill")
        @State private var tabs: [TabBarItem] = [
            TabBarItem(title: "Home", iconName: "heart.fill", badgeCount: 2),
            TabBarItem(title: "Browse", iconName: "magnifyingglass"),
            TabBarItem(title: "Discover", iconName: "globe"),
            TabBarItem(title: "Profile", iconName: "person.fill")
        ]
        @StateObject private var delegate = TBDelegate()
        
        var body: some View {
            TabBarViewBuilderWithDelegate(delegate: delegate) {
                RoundedRectangle(cornerRadius: 0)
                    .opacity(0)
                
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.orange)
                    .tabBarItem(tab: tabs[0], selection: selection)
                    .edgesIgnoringSafeArea(.all)
                
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.red)
                    .tabBarItem(tab: tabs[1], selection: selection)
                    .edgesIgnoringSafeArea(.all)
            } tabBar: {
                TabBarDefaultView(tabs: tabs, selection: $selection, backgroundColor: .red)
            } hoverBar: {
                SwipeUpViewBuilder(isFullScreen: $delegate.hoverIsFullScreen, backgroundColor: .pink) {
                    ZStack {
                        Text("Hey")
                    }
                } collapsedView: {
                    Rectangle()
                        .frame(height: 50)
                }
            }
            .onReceive(delegate.$hoverIsFullScreen) { isFullScreen in
                delegate.hideTabBar = isFullScreen
            }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
