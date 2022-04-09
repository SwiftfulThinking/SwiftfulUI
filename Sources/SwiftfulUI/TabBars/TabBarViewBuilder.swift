//
//  TabBarViewBuilder.swift
//  Catalog
//
//  Created by Nick Sarno on 11/13/21.
//

import SwiftUI

public struct TabBarViewBuilder<Content:View, TabBar: View>: View {
    
    public enum DisplayStyle {
        case vStack
        case zStack
    }

    let style: DisplayStyle
    let content: Content
    let tabBar: TabBar

    public init(
        style: DisplayStyle = .vStack,
        @ViewBuilder content: () -> Content,
        @ViewBuilder tabBar: () -> TabBar) {
        self.style = style
        self.content = content()
        self.tabBar = tabBar()
    }
        
    public var body: some View {
        layout
    }
    
    @ViewBuilder var layout: some View {
        switch style {
        case .vStack:
            VStack(spacing: 0) {
                ZStack {
                    content
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                tabBar
            }
        case .zStack:
            ZStack(alignment: .bottom) {
                content
                tabBar
            }
        }
    }
}

struct TabBarViewBuilder_Previews: PreviewProvider {
    
    struct PreviewView: View {
        @State var selection: TabBarItem = TabBarItem(title: "Home", iconName: "heart.fill")
        @State private var tabs: [TabBarItem] = [
            TabBarItem(title: "Home", iconName: "heart.fill"),
            TabBarItem(title: "Browse", iconName: "magnifyingglass"),
            TabBarItem(title: "Discover", iconName: "globe"),
            TabBarItem(title: "Profile", iconName: "person.fill")
        ]
        
        var body: some View {
            TabBarViewBuilder {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.blue)
                    .tabBarItem(tab: tabs[0], selection: selection)
                    .edgesIgnoringSafeArea(.all)
                
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.red)
                    .tabBarItem(tab: tabs[1], selection: selection)
                    .edgesIgnoringSafeArea(.all)
            } tabBar: {
                TabBarDefaultView(selection: $selection, tabs: tabs)
            }
        }
    }
    
    static var previews: some View {
        PreviewView()
    }
}
