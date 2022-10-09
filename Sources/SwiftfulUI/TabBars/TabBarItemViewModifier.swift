//
//  TabBarItemViewModifier.swift
//  Catalog
//
//  Created by Nick Sarno on 11/14/21.
//

import Foundation
import SwiftUI

struct TabBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [AnyHashable] = []
    
    static func reduce(value: inout [AnyHashable], nextValue: () -> [AnyHashable]) {
        value += nextValue()
    }
}

struct TabBarItemViewModifer: ViewModifier {
    
    @State private var didLoad: Bool = false
    let tab: AnyHashable
    let selection: AnyHashable
    
    func body(content: Content) -> some View {
        ZStack {
            if didLoad || selection == tab {
                content
                    .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
                    .opacity(selection == tab ? 1 : 0)
                    .onAppear {
                        didLoad = true
                    }
            }
        }
    }

}

public extension View {
    
    /// Tag a View with a value. Use selection to determine which tab is currently displaying.
    func tabBarItem(tab: AnyHashable, selection: AnyHashable) -> some View {
        modifier(TabBarItemViewModifer(tab: tab, selection: selection))
    }
    
}
